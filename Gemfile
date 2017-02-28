source 'https://rubygems.org'

group :lint do
  gem 'foodcritic', '~> 4.0'
  gem 'rubocop',    '= 0.28.0'
end

group :unit do
  gem 'berkshelf',  '~> 4.0'
  gem 'chefspec',   '~> 4.0'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.3.1'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.15'
end

group :kitchen_cloud do
  gem 'kitchen-digitalocean', '~> 0.8'
  gem 'kitchen-ec2',          '~> 0.8'
end

group :development do
  gem 'rb-fsevent'
  gem 'guard', '~> 2.4'
  gem 'guard-kitchen'
  gem 'guard-foodcritic'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'rake'
end
