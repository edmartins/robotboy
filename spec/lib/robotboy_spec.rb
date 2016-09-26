require 'spec_helper'
require './lib/robotboy'

describe Robotboy do

  context 'when option is missing' do
    subject { Robotboy.query_alert() }
    it { expect { subject }.to raise_error(ArgumentError, 'option argument is missing') }
  end

  context 'when xls' do
    subject { Robotboy.query_alert("test_xls") }
    it { expect(subject).to be_kind_of(Spreadsheet::Workbook) }
  end

  context 'when text size' do
    subject { Robotboy.query_alert("test_text_size") }
    it { expect(subject).to be_kind_of(String) }
  end

  context 'when text count' do
    subject { Robotboy.query_alert("test_text_count") }
    it { expect(subject).to be_kind_of(String) }
  end

  context 'with params at file' do
    subject { Robotboy.query_alert("test_params") }
    it { expect(subject).to be_kind_of(String) }
  end

  context 'with params' do
    subject { Robotboy.query_alert("test_params_env", @mail_params_test) }
    it { expect(subject).to be_kind_of(String) }
  end

end