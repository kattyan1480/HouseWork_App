ActionMailer::Base.add_delivery_method :sendgrid_actionmailer, SendGrid::Mail::SMTPAPI do |config|
  config.api_key = ENV['SENDGRID_API_KEY']
end