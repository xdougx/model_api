require 'model_api/version'
require 'active_model'
require 'active_support/concern'
require 'rest_client'

# Namespace for this library, this library have the responsability
# to setup models and call http requests in the API
module ModelApi
end

require 'model_api/configuration'
require 'model_api/requester'
require 'model_api/base'
