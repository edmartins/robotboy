require "bundler/gem_tasks"
require "./lib/robotboy.rb"

task :query_alert do
  ##
  # When you run the Robotboy the variable "option" (required) and "params" (optional) must be defined in the environment.
  # 
  # "option" variable is always referring always to two files:
  # 
  #   - config/options/<file>.yml
  #     File with the database settings, rules and email dispatch options.
  #     
  #   - config/queries/<file>.sql
  #     File with the SQL query that will be executed in the database and sent.
  #     
  Robotboy.query_alert(ENV['option'], ENV['params'])
end
