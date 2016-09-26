require 'spec_helper'
require './lib/robotboy/query_alert'

describe QueryAlert do

  context 'without options' do
    subject { QueryAlert.new }
    it { expect { subject }.to raise_error(ArgumentError, 'option argument is missing') }
  end

  context 'when option dont have file associated' do
    subject { QueryAlert.new("teste") }
    it { expect { subject }.to raise_error(ArgumentError, 'config/options/teste.yml file is missing') }
  end

  let(:query_alert) { QueryAlert.new("test_query_alert") }

  context 'with valid option' do
    subject { query_alert }
    it { expect(subject).to be_kind_of(QueryAlert) }
  end

  context 'when connect to db' do
    subject { query_alert.db_connect }
    it { expect(subject).to be_kind_of(Mysql2::Client) }
  end

  context 'when query is executed' do
    let(:client) { query_alert.db_connect }
    subject { query_alert.execute(client) }
    it { expect(subject).to be_kind_of(Mysql2::Result) }
  end

  context 'when results has alert' do
    let(:client) { query_alert.db_connect }
    let(:results) { query_alert.execute(client) }
    subject { query_alert.has_alert?(results) }
    it { expect(subject).to eq true }
  end
  
end