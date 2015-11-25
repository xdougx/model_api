module ModelApi
  # Configures global settings for ModelApi
  #   ModelApi.configure do |config|
  #     config.key = "secret"
  #     config.uuid = "secret"
  #     config.env = :development
  #     config.url = {
  #       development: "http://localhost:3000",
  #       test: "http://test-domain.com.br",
  #       production: "http://domain.com.br/api/v1"
  #     }
  #   end
  def self.configure(&_block)
    yield(config())
  end

  # Global settings for ModelApi
  def self.config
    @config ||= ModelApi::Configuration.new
  end

  # this configuration class has all attributes to configure
  # the api url and authorizations params
  class Configuration
    # principal attributes to execute an http request
    attr_accessor :uuid, :key, :url, :env

    # constructor that set default values
    def initialize
      self.key = ''
      self.uuid = ''
      self.url = {
        development: 'http://localhost:3000'
      }
      self.env = :development
    end
  end
end
