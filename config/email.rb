require 'mail'

Mail.defaults do
  delivery_method :smtp, {
    :address              => App.settings['email_smtp_server'],
    :port                 => App.settings['email_smtp_port'],
    :domain               => App.settings['email_smtp_domain'],
    :user_name            => App.settings['email_smtp_username'],
    :password             => App.settings['email_smtp_password'],
    :authentication       => 'plain',
    :enable_starttls_auto => true
  }
end
