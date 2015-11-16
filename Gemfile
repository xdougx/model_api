source 'https://rubygems.org'

# Specify your gem's dependencies in model_api.gemspec
gemspec

gem 'sdoc'
gem 'exceptions-resource', github: 'xdougx/exceptions-resource',
                           require: 'exceptions'

group :development, :test do
  gem 'rubycritic', require: false
  gem 'rubocop', require: false
  %w(rspec rspec-core rspec-mocks rspec-support
     rspec-its rspec-expectations).each do |repo|
    gem repo, github: "rspec/#{repo}", branch: :master
  end
end
