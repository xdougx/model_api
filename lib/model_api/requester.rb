module ModelApi
  # the requester class have the object to
  # call http requests in the configured url
  # E.G.
  #     ModelAPI::Requester.new(:get, "url", "url_params", {body: "data"})
  class Requester
    # `method` is https request method could be `get`, `post`, `put` or `delete`
    attr_accessor(:method)
    # `path` is the url path to the request
    attr_accessor(:path)
    # `params` is url path params
    attr_accessor(:params)
    # `body` is content body for a post or put method
    attr_accessor(:body)
    # `resource` is response from a http request
    attr_accessor(:resource)
    # `request` is the request object from rest_client
    attr_accessor(:request)
    # `result` is status from the request
    attr_accessor(:result)
    # `header` is the http request header
    attr_accessor(:header)
    # `@@session_token` is the current user token session
    @@session_token = ""

    # construct and execute a new request
    def initialize(method, path, body = {}, params = {}, header = {})
      @method = method
      @path = path
      @body = body
      @params = params
      setup_header(header)
      run
      valid?
    end

    class << self
      attr_accessor :session_token
    end


    protected

    def run
      send(@method)
    end

    # setup the resource, request and result data from a request
    def setup(resource, request, result)
      @resource = JSON.parse(resource)
      @request = request
      @result = result
    end

    # call the url with GET method
    def get
      RestClient.get(url, @header) do |rso, req, res|
        setup(rso, req, res)
      end
    end

    # call the url with POST method
    def post
      RestClient.post(url, @body, @header) do |rso, req, res|
        setup(rso, req, res)
      end
    end

    # call the url with PUT method
    def put
      RestClient.put(url, @body, @header) do |rso, req, res|
        setup(rso, req, res)
      end
    end

    # call the url with DELETE method
    def delete
      RestClient.delete(url, @header) do |rso, req, res|
        setup(rso, req, res)
      end
    end

    # create the base64 authentication
    def auth
      "Basic #{Base64.strict_encode64("#{config.uuid}:#{config.key}")}"
    end

    # return the config_api object
    def config
      ModelApi.config
    end

    # build the url request
    def url
      url = "#{config.url[config.env]}/#{@path}"
      url = "#{url}?#{@params.to_param}" unless @params.empty?
      url
    end

    def setup_header(header = {})
      @header = { Authorization: auth, content_type: :json, accept: :json }
      @header["Session-Token"] = @@session_token unless @@session_token.blank?
      @header.merge!(header) if !header.empty? or header.blank?
      @header
    end

    # checkup if requests status is ok(200)
    def ok?
      @result.code.to_i != 200
    end

    # checkup if has error key in the response
    def error?
      return if @resource.is_a?(Array)
      @resource.key?("error")
    end

    # raise error if isnt ok or has error key
    def valid?
      raise_error(@resource['error']) if ok? || error?
    end

    def raise_error(error)
      fail(Exceptions::Resource.build(error))
    end
  end
end
