ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.1and1.com",
  :port                 => 587, 
  :authentication => :login,
  :user_name            => 'support@hairillusion.net',
  :password       => 'h41r1llus10n',
  :enable_starttls_auto => true,
  :domain =>"1and1.com"
}
