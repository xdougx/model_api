# Namespace for this library, this library have the responsability
# to setup models and call http requests in the API
module ModelApi
  # Model API Base is the principal class to create an model
  class Base
    include ActiveModel::Model
    include ActiveModel::Serialization

    attr_accessor :created_at, :updated_at

    # the requester is a proxy to the Requester Class
    REQUESTER = ModelApi::Requester

    # return the requester is a proxy to the Requester CLass
    def requester
      REQUESTER
    end

    # constructor to setup all attributes with an hash
    def initialize(params = {})
      parameters(params)
    end

    # convert the model object to json without nil values
    def to_json(options = {})
      serializable_hash.compact.to_json(options)
    end

    # setup the parameters to the object receiving an hash
    # @param [Hash] params
    def parameters(params)
      params.each do |key, value|
        send("#{key}=".to_sym, value) if self.respond_to? key
      end
    end

    # [PUT] /model_pluralized/:id
    # call the api method and updates the objects
    def update(body, params = {}, header = {})
      request = requester.new(:put, "#{to_url}/#{id}", body, params, header)
      parameters(request.resource)
    end

    # [PUT] model_pluralized/:model_id/archive
    # call the api method and updates the object to an `archived` state
    # atualiza o status do objeto para 'archived'
    def archive(body = {}, params = {}, header = {})
      request = requester.new(:put, "#{to_url}/#{id}/archive", body, params, header)
      parameters(request.resource)
    end

    # [PUT] /model_pluralized/:model_id/active
    # call the api method and updates the object to an `archived` state
    def active(body = {}, params = {}, header = {})
      request = requester.new(:put, "#{to_url}/#{id}/active", body, params, header)
      parameters(request.resource)
    end


    # check if the object is active
    # @return [Boolean]
    def active?
      status == 'active' if self.respond_to? :status
    end

    # build the url name for the model
    def to_url
      self.class.to_url
    end

    # build the url name for the model namespace
    def to_param_namespace
      self.class.to_param_namespace
    end

    def created_at=(value)
      @created_at = Time.parse(value)
    end

    def updated_at=(value)
      @updated_at = Time.parse(value)
    end

    class << self

      def define_attributes(*attributes)
        class_eval do
          attr_accessor *attributes.delete_if {|attr| attr.match /created_at|updated_at/ }

          define_method(:attributes) do
            @attributes ||= attributes.each_with_object({}) do |attr, attrs|
              attrs[attr] = send(attr)
            end
          end
        end
      end

      # method to create an object and setup the attributes
      # that responds to, receive an hash as parameter
      def build(params)
        return new(params) if params.is_a?(Hash)
        raise("unexpected parameter, expected Hash, received #{params.class}")
      end

      # [GET] /model_pluralized
      # method to recovery all objects from an index
      def all(params = {}, header = {})
        request = requester.new(:get, to_url, nil, params, header)
        request.resource.map do |model|
          build(model)
        end
      end

      # [GET] /model_pluralized
      # method to recovery all objects from an index with pagination source
      #    { objects: [],
      #      pagination:  {
      #        current_page: page,
      #        total_objects: count,
      #        per_page: per_page,
      #        total_pages: total_pages(per_page)
      #     }
      #   }
      def all_with_pagination(params = {}, header = {})
        request = requester.new(:get, to_url, nil, params, header)
        request.resource['objects'] = request.resource['objects'].map do |attrs|
          request.resource['objects'] = new(attrs)
        end
        request.resource
      end

      # [POST] /model_pluralized
      # method to create an object in the api
      def create(body, params = {}, header = {})
        request = requester.new(:post, to_url, body, params, header)
        build(request.resource)
      end

      # [GET] /model_pluralized/find_by
      # method to call find by attributes
      def find_by(attributes = {}, options = {}, header = {})
        search = { search: attributes }.merge!(options)
        request = requester.new(:get, "#{to_url}/find_by", nil, search, header)
        request.resource.map do |element|
          build(element)
        end
      end

      # [GET] /model_pluralized/find_by_name
      # method to call find by name in the api
      def find_by_name(params, header = {})
        request = requester.new(:get, "#{to_url}/find_by_name", {}, params, header)
        request.resource.map do |model|
          build(model)
        end
      end

      # [GET] /model_pluralized/id
      # this method recover an object by id
      def find(id, params = {}, header = {})
        request = requester.new(:get, "#{to_url}/#{id}", nil, params, header)
        build(request.resource)
      end

      # build the url name for the model
      def to_url
        name.underscore.downcase.pluralize
      end

      # build the url name for the model namespace
      def to_param_namespace
        name.downcase
      end

      # return the requester is a proxy to the Requester CLass
      def requester
        REQUESTER
      end
    end
  end
end
