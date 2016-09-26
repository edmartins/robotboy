require 'spec_helper'
require './lib/robotboy/database_connector'

describe DatabaseConnector do

  subject { DatabaseConnector.new(options) }

  context 'with all options' do
    let(:options) { { 
      adapter: @db_adapter,
      host: @db_host,
      port: @db_port,
      username: @db_username,
      password: @db_password,
      database: @db_database
    } }
    
    it { is_expected.to be_kind_of(DatabaseConnector) }
  end

  context 'without adapter' do
    let(:options) { { 
      host: @db_host,
      port: @db_port,
      username: @db_username,
      password: @db_password,
      database: @db_database
    } }

    it { expect { subject }.to raise_error(ArgumentError, 'database adapter is required') }
  end

  context 'without host' do
    let(:options) { { 
      adapter: @db_adapter,
      port: @db_port,
      username: @db_username,
      password: @db_password,
      database: @db_database
    } }

    it { expect { subject }.to raise_error(ArgumentError, 'database host is required') }
  end

  context 'without port' do
    let(:options) { { 
      adapter: @db_adapter,
      host: @db_host,
      username: @db_username,
      password: @db_password,
      database: @db_database
    } }

    it { expect { subject }.to raise_error(ArgumentError, 'database port is required') }
  end

  context 'without username' do
    let(:options) { { 
      adapter: @db_adapter,
      host: @db_host,
      port: @db_port,
      password: @db_password,
      database: @db_database
    } }

    it { expect { subject }.to raise_error(ArgumentError, 'database username is required') }
  end

  context 'without password' do
    let(:options) { { 
      adapter: @db_adapter,
      host: @db_host,
      port: @db_port,
      username: @db_username,
      database: @db_database
    } }

    it { expect { subject }.to raise_error(ArgumentError, 'database password is required') }
  end

  context 'without database' do
    let(:options) { { 
      adapter: @db_adapter,
      host: @db_host,
      port: @db_port,
      username: @db_username,
      password: @db_password
    } }

    it { expect { subject }.to raise_error(ArgumentError, 'database database is required') }
  end

  context 'when adapter is sqlite3' do
    let(:options) { { 
      adapter: "sqlite3",
      host: @db_host,
      port: @db_port,
      username: @db_username,
      password: @db_password,
      database: @db_database
    } }

    it { expect { subject }.to raise_error(ArgumentError, 'for a while only mysql2 adapter is supported') }
  end

end