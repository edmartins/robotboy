require 'spec_helper'
require './lib/robotboy/text_mailer'
require './lib/robotboy/database_connector'

describe TextMailer do

  let(:db_options) { { 
    adapter: @db_adapter,
    host: @db_host,
    port: @db_port,
    username: @db_username,
    password: @db_password,
    database: @db_database
  } }
  let(:client) { DatabaseConnector.new(db_options).client }

  let(:results) { client.query(@mail_test_query) }
  let(:mail_options) { {
    from: @mail_test_from,
    to: @mail_test_to,
    subject: @mail_test_subject
  } }

  subject { TextMailer.new(results, mail_options) }

  context 'send mail' do
    it { expect(subject.send).to eq @mail_test_expected_result }
  end

end