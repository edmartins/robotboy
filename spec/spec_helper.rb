require 'yaml'

options = YAML.load_file("./config/test.yml")

database_options = options['database']
mail_options = options['mail']

RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:all) do
    @db_adapter  = database_options['adapter']
    @db_host     = database_options['host']
    @db_port     = database_options['port']
    @db_username = database_options['username']
    @db_password = database_options['password']
    @db_database = database_options['database']
    
    @mail_test_from            = mail_options['basic_test']['from']
    @mail_test_to              = mail_options['basic_test']['to']
    @mail_test_subject         = mail_options['basic_test']['subject']
    @mail_test_query           = mail_options['basic_test']['query']
    @mail_test_expected_result = mail_options['basic_test']['expected_result']

    @mail_xls_test_from            = mail_options['xls_test']['from']
    @mail_xls_test_to              = mail_options['xls_test']['to']
    @mail_xls_test_subject         = mail_options['xls_test']['subject']
    @mail_xls_test_body            = mail_options['xls_test']['body']
    @mail_xls_test_query           = mail_options['xls_test']['query']
    @mail_xls_test_expected_result = mail_options['xls_test']['expected_result']

    @mail_params_test = mail_options['params_test']['params']
  end

end
