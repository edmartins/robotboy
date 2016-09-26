require './lib/robotboy/mailer.rb'
require 'spreadsheet'
require 'fileutils'

class XlsMailer < Mailer

  ##
  # :method: send
  # 
  # *All classes from Mailer class need implement this method
  # Create .xls file from query results and send email
  # 
  def send
    current_date = Time.now.strftime("%Y_%m_%d")
    filename = "#{current_date}_relatorio.xls"

    xls_book = Spreadsheet::Workbook.new
    xls_bold_format = Spreadsheet::Format.new({ :weight => :bold})
    xls_sheet = xls_book.create_worksheet name: filename
    xls_header_columns = @results.first.keys
    curr_index = 0
    xls_sheet.row(curr_index).push *xls_header_columns
    xls_header_columns.each_with_index { |column, index| xls_sheet.row(curr_index).set_format(index, xls_bold_format) }

    @results.each do |row|
      xls_row_columns = []
      xls_header_columns.each do |column|
        xls_row_columns << row[column]
      end
      xls_sheet.row(curr_index = curr_index + 1).push *xls_row_columns
    end

    file_path = "#{create_temporary_directory}/#{filename}"
    xls_book.write file_path

    @mail.attachments[filename] = File.read(file_path)
    @mail.body = if @mail_options.has_key?(:body)
      @mail_options[:body]
    else
      "The requested file is attached."
    end

    @mail.deliver!

    xls_book
  end

  def create_temporary_directory
    temp_dir_location = "tmp/#{Time.now.to_i}_#{Random.rand(99999)}"
    FileUtils.mkdir_p(temp_dir_location)
    temp_dir_location
  end

end