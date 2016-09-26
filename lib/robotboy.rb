require "robotboy/version"
require "./lib/robotboy/query_alert.rb"

module Robotboy

  def self.query_alert(option=nil, params=nil)
    ##
    # Loads the QueryAlert class with the configurations defined in the directory config/
    query_alert = QueryAlert.new(option, params)

    ##
    # Connect to the database defined in config/options/<file>.yml
    db_client = query_alert.db_connect

    ##
    # Executes the query defined in config/queries/<file>.sql
    results = query_alert.execute(db_client)

    ##
    # Send e-mail if the rules defined in config/options/<file>.yml are met
    query_alert.send_mail(results) if query_alert.has_alert?(results)
  end

end
