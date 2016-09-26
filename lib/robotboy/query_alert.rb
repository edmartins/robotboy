require 'yaml'
require "./lib/robotboy/database_connector.rb"
require "./lib/robotboy/mail_factory.rb"

class QueryAlert

  attr_accessor :options

  ## 
  # :method: initialize
  # 
  # Load .yml and .sql files with their settings
  # 
  def initialize(option=nil, params=nil)
    @option = option
    validate(@option)
    @options = YAML.load_file("./config/options/#{@option}.yml")

    ##
    # Condition necessary for rspec tests, it was necessary not to expose sensitive data
    # 
    if ["test_xls",
        "test_text_size",
        "test_text_count",
        "test_params",
        "test_params_env",
        "test_query_alert"].include?(@option)
      
      test_options = YAML.load_file("./config/test.yml")
      test_database_options = test_options['database']
      test_mail_options = test_options['mail']['basic_test']

      @options["database"] = {
        "adapter" => test_database_options['adapter'],
        "host" => test_database_options['host'],
        "port" => test_database_options['port'],
        "username" => test_database_options['username'],
        "password" => test_database_options['password'],
        "database" => test_database_options['database']
      }

      @options["email"]["from"] = test_mail_options['from']
      @options["email"]["to"] = test_mail_options['to']
    end


    @query_options = @options['query']
    @params = params
  end

  ##
  # :method: db_connect
  # 
  # Returns database client
  def db_connect
    database_connect_options = @options['database']
    db_connector = DatabaseConnector.new(database_connect_options)
    return db_connector.client
  end

  ##
  # :method: execute
  # 
  # Parse params from the environment or from .yml config file
  # Returns query results
  # 
  def execute(db_client)
    query_file = @query_options['file']
    query_file_path = "./config/queries/#{query_file}"
    query_content = File.read(query_file_path)

    if @query_options.has_key?('params') || @params
      query_params = @query_options['params'] ? @query_options['params'] : @params.split(',')
      query_params.each_with_index do |p, i|
        query_content = query_content.gsub(/@@#{i}@@/, p)
      end
    end

    return db_client.query(query_content)
  end

  ##
  # :method: has_alert?
  # 
  # Checks in particular result of a query meets the rules set in the config file .yml
  # Returns true or false, whether there is a alert
  # 
  def has_alert?(results)
    results_format = @query_options['results_format']
    alert_condition = @query_options['alert_condition']

    alert = false
    if results_format.eql?("count")
      count_value = results.first.map{|key,value| value}.first
      alert = eval("#{count_value} #{alert_condition}")
    elsif results_format.eql?("size")
      alert = eval("#{results.size} #{alert_condition}")
    elsif results_format.eql?("xls")
      alert = true
    end

    return alert
  end

  ##
  # :method: send_mail
  # 
  # Send email with alert results, MailFactory was created to decide
  # whether it is an email or text with an .xls file
  # 
  def send_mail(results)
    mail = MailFactory.request(@query_options['results_format'], results, @options['email'])
    mail.send
  end

  ##
  # :method: validate
  # 
  # Validates the parameter "option" and the .yml file
  # 
  def validate(option)
    raise ArgumentError, 'option argument is missing' unless option
    option_path = "./config/options/#{option}.yml"
    raise ArgumentError, "config/options/#{option}.yml file is missing" unless File.exist?(option_path)
  end
end