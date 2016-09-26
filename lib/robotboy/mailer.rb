require 'mail'
require 'yaml'
require './lib/robotboy/utils/hash_utils'

##
# Father class with sending e-mail settings
# 
class Mailer
  include HashUtils

  MAIL_CONFIG = YAML.load_file("./config/mail.yml")

  ##
  # Email default rules defined at config/mail.yml
  # 
  Mail.defaults do
    delivery_method :smtp, { 
      address:              MAIL_CONFIG['address'],
      port:                 MAIL_CONFIG['port'],
      domain:               MAIL_CONFIG['domain'],
      user_name:            MAIL_CONFIG['user_name'],
      password:             MAIL_CONFIG['password'],
      authentication:       MAIL_CONFIG['authentication'],
      enable_starttls_auto: true
    }
  end

  ##
  # :method: initialize
  # 
  # define email rules for send alert messages
  # 
  def initialize(results, mail_options)
    @results = results
    @mail_options = keys_to_symbol(mail_options)

    from = @mail_options[:from]
    to = @mail_options[:to]
    cc = @mail_options[:cc]
    subject = @mail_options[:subject]
    
    @mail = Mail.new do
      from    from
      to      to
      cc      cc
      subject subject
    end
  end

end