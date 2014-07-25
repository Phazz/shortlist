source 'https://rubygems.org'

###--- Base ---###
gem 'rails',                      '4.1.4'
gem 'pg',                         '~> 0.17.1'
gem 'sass-rails',                 '~> 4.0.3'
gem 'uglifier',                   '>= 1.3.0'
gem 'coffee-rails',               '~> 4.0.1'
gem 'jquery-rails',               '~> 3.1.1'
gem 'jquery-ui-rails',            '~> 5.0.0'
gem 'jbuilder',                   '~> 2.1.2'
gem 'sdoc',                       '~> 0.4.0', group: :doc
gem 'spring',                     '~> 1.1.3', group: :development


###--- Authentication ---###
gem 'devise',                     '~> 3.2.4'
gem 'omniauth-github',            '~> 1.1.2'
gem 'omniauth-gplus',             '~> 1.2.0'
gem 'omniauth-facebook',          '~> 1.6.0'
gem 'omniauth-vkontakte',         '~> 1.3.3', git: 'git://github.com/mamantoha/omniauth-vkontakte.git'


###--- Logic ---###
gem 'state_machine',              '~> 1.2.0'


###--- Tools ---###
gem 'haml',                       '~> 4.0.5'
gem 'bootstrap-sass',             '~> 3.1.1'
gem 'compass-rails',              '~> 1.1.7'
gem 'font-awesome-rails',         '~> 4.1.0'
gem 'angularjs-rails',            '~> 1.2.20'
gem 'angular-ui-bootstrap-rails', '~> 0.11.0'
gem 'dalli',                      '~> 2.7.2'
gem 'exception_notification',     '~> 4.0.1'


###--- Deploy ---###
group :development do
  gem 'capistrano',               '~> 2.14.1'
  gem 'capistrano-ext',           '~> 1.2.1'
  gem 'rvm-capistrano',           '~> 1.2.7'
  # gem 'capistrano',               '~> 3.1.0'
  # gem 'capistrano-rails',         '~> 1.1.1'
  # gem 'capistrano-bundler',       '~> 1.1.2'
  # gem 'capistrano-rvm',           '~> 0.1.1'
end


group :development do
  gem 'thin',                     '~> 1.6.2'
  gem 'spring-commands-rspec',    '~> 1.0.2'
end


group :production do
  gem 'unicorn',                  '~> 4.4.0'
end