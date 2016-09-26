require "./lib/robotboy/mailer.rb"

class TextMailer < Mailer

  ##
  # :method: send
  # 
  # *All classes from Mailer class need implement this method
  # Generate text from query results and send email
  # 
  def send
    text = ""

    header_columns = @results.first.keys
    text = text + header_columns.join(";") + "\n"

    @results.each do |row|
      row_columns = []
      header_columns.each do |column|
        row_columns << row[column]
      end
      text = text + row_columns.join(";") + "\n"
    end

    @mail.body text
    @mail.deliver!

    text
  end

end