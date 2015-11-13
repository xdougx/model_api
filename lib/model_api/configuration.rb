module ModelApi
  # Configures global settings for Moip
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
  def self.configure(&block)
    yield(@config)
  end

  # Global settings for Moip
  def self.config
    @config ||= ModelApi::Configuration.new
  end

  class Configuration
    attr_accessor :uuid, :key, :url, :env

    def initialize
      self.key = ""
      self.uuid = ""
      self.url = {
        development: "http://localhost:3000"
      }
      self.env = :development
    end
  end
end