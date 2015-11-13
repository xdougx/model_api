# ModelApi

This ruby gem is an adpter for Kanamobi`s API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'model_api'
```

And then execute:

    $ bundle install


## Dependenies


## Usage

Create your model based on the API with their attributes

```ruby
class MyModel < ModelApi::Base
  attr_accessor(:name, :email, :password, :role)

  def attributes
    {
      name: name, 
      email: email,
      password: password,
      role: role
    }
  end
end
```

Now you can use the basic API methods

```ruby
  my_model = MyModel.find(1)
  puts my_model.name
  => "Douglas"
```



## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/model_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

