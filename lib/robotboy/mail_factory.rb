require "./lib/robotboy/xls_mailer.rb"
require "./lib/robotboy/text_mailer.rb"

class MailFactory

  ##
  # :method: self.request
  # 
  # Format defined in the .yml file
  # Returns an object of XlsMailer or TextMailer classes, they are children of Mailer class, the child classes must implement the send method
  # 
  def self.request(format, results, mail_options)
    if format.eql?("xls")
      mail = XlsMailer.new(results, mail_options)
    else
      mail = TextMailer.new(results, mail_options)
    end

    return mail
  end
end