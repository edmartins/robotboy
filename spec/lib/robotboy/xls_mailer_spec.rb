require 'spec_helper'
require './lib/robotboy/xls_mailer'
require './lib/robotboy/database_connector'
require 'spreadsheet'

describe XlsMailer do
  let(:db_options) { { 
    adapter: @db_adapter,
    host: @db_host,
    port: @db_port,
    username: @db_username,
    password: @db_password,
    database: @db_database
  } }
  let(:client) { DatabaseConnector.new(db_options).client }

  let(:results) { client.query(@mail_xls_test_query) }
  let(:mail_options) { {
    from: @mail_xls_test_from,
    to: @mail_xls_test_to,
    subject: @mail_xls_test_subject,
    body: @mail_xls_test_body
  } }

  subject { XlsMailer.new(results, mail_options) }

  before {
    book = subject.send
    sheet = book.worksheet(0)
    @sheet_text = ""
    sheet.each do |row|
      @sheet_text = @sheet_text + row.join(';') + "\n"
    end
  }

  context 'send mail' do
    it { expect(@sheet_text).to eq @mail_xls_test_expected_result }
  end
end