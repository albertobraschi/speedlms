# Be sure to restart your server when you modify this file
FREE = 0.0
RESOURCE_TYPE = {:admin => "Admin", :owner => "Owner", :tutor => "Tutor", :student => "Student"}
# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'development'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|  
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_proj_session',
    :secret      => '1e7e3f46984858be9afa42f0ea6f634c8a144e8ed3edf389db38452218a7d5491c6c95f740d325bde16493802413e36fb5a0cc204c4414fed20f7b4fe81d1cb0'
  }
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
  end
  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  

  # Adding the gems in application/vendor.
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end

end
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default_content_type = "text/html"


# CONFIGURING THE WEB SERVER TO ACCEPT CUSTOMIZED SUBDOMAINS FOR TESTING PURPOSE
# Step1
# go to the httpd.conf file in the etc/apache directory and add the following code there

#<VirtualHost *>
      #  ServerName speedlms.dev
      #  ServerAlias *.speedlms.dev

      #  DocumentRoot /Users/vibha/work/speedlms/public

     # <Directory "/Users/vibha/work/speedlms/public">
     #         Options FollowSymLinks
     #         AllowOverride None
     #         Order allow,deny
     #         Allow from all
     # </Directory>

     # RewriteEngine On

     #  RewriteCond %{DOCUMENT_ROOT}/system/maintenance.html -f
     #  RewriteRule . /system/maintenance.html [L]

     #  RewriteCond %{DOCUMENT_ROOT}%{REQUEST_URI} -f
     #  RewriteRule (.*) $1 [L]

     #  ProxyRequests Off

     #  <Proxy *>
             #  Order deny,allow
             #  Allow from all
     # </Proxy>

     # ProxyPass / http://127.0.0.1:3000/
     # ProxyPassReverse / http://127.0.0.1:3000/

#</VirtualHost>

# step2

#  sudo vi etc/hosts and add this code at the end 
#   127.0.0.1       speedlms.dev
#   127.0.0.1       yoursubdomain.speedlms.dev

#step 3

# Restart your Apache server with the following command
# sudo /usr/sbin/apachet l start


unless RAILS_ENV == 'production'
  PAYPAL_ACCOUNT = 'sandboxaccount@example.com'
  ActiveMerchant::Billing::Base.mode = :test
else
  PAYPAL_ACCOUNT = 'paypalaccount@example.com'
end

