module ModelApi
  class Requester
    class << self
      def get(path, params = {})
        RestClient.get(url(path, params), header) do |resource, request, result| 
          resource = JSON.parse(resource)
          return resource if ok?(resource) or invalid?(resource)
          fail(Exceptions::Resource.build(resource["error"]))
        end
      end

      def post(path, body = {}, params = {})
        RestClient.post(url(path, params), body, header) do |resource, request, result| 
          resource = JSON.parse(resource)
          return resource if ok?(result) or invalid?(resource) 
          fail(Exceptions::Resource.build(resource["error"]))
        end
      end

      def put(path, body = {}, params = {})
        RestClient.put(url(path, params), body, header) do |resource, request, result| 
          resource = JSON.parse(resource)
          return resource if ok?(resource) or invalid?(resource)
          fail(Exceptions::Resource.build(resource["error"]))
        end
      end

      def delete
        RestClient.delete(url(path, params), header) do |resource, request, result| 
          resource = JSON.parse(resource)
          return resource if ok?(resource) or invalid?(resource)
          fail(Exceptions::Resource.build(resource["error"]))
        end
      end

      def url(path, params = {})
        url = "#{config.url[config.env]}/#{path}"
        url = "#{url}?#{params.to_param}" unless params.empty?
        url
      end

      # verifica se a resposta da API possui algum erro
      # @resource [Hash] response
      def ok?(result)
        result.code.to_i == 200
      end

      def invalid?(resource)
        resource.key?("error")
      end

      def header
        { :Authorization => auth, :content_type => :json, :accept => :json }
      end

      def config
        ModelApi.config
      end

      def auth
        auth = Base64.strict_encode64("#{config.uuid}:#{config.key}")
        "Basic #{auth}"
      end

    end
  end
end



  # private
  # def base
  #   if Rails.env.development?
  #     "http://localhost:3000/v1"
  #   elsif Rails.env.production?
  #     # "http://171.30.7.148/v1" # production
  #     "http://54.191.177.215/v2" # staging
  #   else
  #     "http://localhost:3000/v1"
  #   end
  # end
