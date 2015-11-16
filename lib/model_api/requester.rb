module ModelApi
  # the requester class have the object to call http requests in the configured url 
  class Requester
    class << self
      # call the url with GET method
      def get(path, params = {})
        RestClient.get(url(path, params), header) do |resource, request, result| 
          resource = JSON.parse(resource)
          return resource if ok?(resource) or invalid?(resource)
          fail(Exceptions::Resource.build(resource["error"]))
        end
      end

      # call the url with POST method
      def post(path, body = {}, params = {})
        RestClient.post(url(path, params), body, header) do |resource, request, result| 
          resource = JSON.parse(resource)
          return resource if ok?(result) or invalid?(resource) 
          fail(Exceptions::Resource.build(resource["error"]))
        end
      end

      # call the url with PUT method
      def put(path, body = {}, params = {})
        RestClient.put(url(path, params), body, header) do |resource, request, result| 
          resource = JSON.parse(resource)
          return resource if ok?(resource) or invalid?(resource)
          fail(Exceptions::Resource.build(resource["error"]))
        end
      end

      # call the url with DELETE method
      def delete
        RestClient.delete(url(path, params), header) do |resource, request, result| 
          resource = JSON.parse(resource)
          return resource if ok?(resource) or invalid?(resource)
          fail(Exceptions::Resource.build(resource["error"]))
        end
      end

      # build the url request
      def url(path, params = {})
        url = "#{config.url[config.env]}/#{path}"
        url = "#{url}?#{params.to_param}" unless params.empty?
        url
      end

      # checkup if requests status is ok(200)
      def ok?(result)
        result.code.to_i == 200
      end

      # checkup if the response has error key
      def invalid?(resource)
        resource.key?("error")
      end

      # the header request as json with authorization
      def header
        { :Authorization => auth, :content_type => :json, :accept => :json }
      end

      # return the config_api object
      def config
        ModelApi.config
      end
      # create the base64 authentication
      def auth
        auth = Base64.strict_encode64("#{config.uuid}:#{config.key}")
        "Basic #{auth}"
      end

    end
  end
end
