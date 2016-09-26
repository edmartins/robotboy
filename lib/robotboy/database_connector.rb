require 'mysql2'
require './lib/robotboy/utils/hash_utils'

class DatabaseConnector
  include HashUtils

  attr_accessor :client

  ##
  # :method: initialize
  # 
  # Perform the connection to the database defined in .yml file
  # Returns the established client
  # 
  def initialize(connect_options)
    connect_options = keys_to_symbol(connect_options)

    raise ArgumentError, 'database adapter is required' unless connect_options.has_key?(:adapter)
    raise ArgumentError, 'database host is required' unless connect_options.has_key?(:host)
    raise ArgumentError, 'database port is required' unless connect_options.has_key?(:port)
    raise ArgumentError, 'database username is required' unless connect_options.has_key?(:username)
    raise ArgumentError, 'database password is required' unless connect_options.has_key?(:password)
    raise ArgumentError, 'database database is required' unless connect_options.has_key?(:database)

    if connect_options[:adapter].eql? "mysql2"
      @client = Mysql2::Client.new(
        host: connect_options[:host],
        port: connect_options[:port],
        username: connect_options[:username],
        password: connect_options[:password],
        database: connect_options[:database]
      )
    else
      raise ArgumentError, 'for a while only mysql2 adapter is supported'
    end
    
  end
end