module ModelApi
  # Model API Base is the principal class to create an model
  class Base 
    include ActiveModel::Model
    include Requester
    include Header

    # the requester is a proxy to the Requester CLass
    @@requester = ModelApi::Requester
    
    # constructor to setup all attributes with an hash
    def initialize(params = {})
      set_parameters(params)
    end

    # convert the model object to json without nil values
    def to_json(options = {})
      self.serializable_hash.compact.to_json(options)
    end

    # setup the parameters to the object receiving an hash
    # @param [Hash] params
    def set_parameters(params)
      params.each do |key, value|
        self.send("#{key}=".to_sym, value) if self.respond_to? key
      end
    end
    
    # [PUT] /model_pluralized/:id
    # call the api method and updates the objects
    def update(params)
      resource = @@requester.put(("#{to_url}/#{id}"), params)
      set_parameters(resource)
    end

    # [PUT] model_pluralized/:model_id/archive
    # call the api method and updates the object to an `archived` state
    # atualiza o status do objeto para 'archived'
    def archive(params)
      resource = @@requester.put("#{to_url}/#{id}/archive"), params)
      set_parameters resource
    end

    # [PUT] /model_pluralized/:model_id/active
    # call the api method and updates the object to an `archived` state
    def active(params)
      resource = @@requester.put("#{to_url}/#{id}/active"), params)
      set_parameters(resource)
    end

    # check if the object is active
    # @return [Boolean]
    def active?
      if self.respond_to? :status
        self.status == 'active'
      end
    end

    # build the url name for the model
    def to_url
      self.class.to_url
    end

    # build the url name for the model namespace
    def to_param_namespace
      self.class.to_param_namespace
    end

    class << self
      # method to create an object and setup the attributes that responds to, receive an hash as parameter
      def build(params)
        return new(params) if params.is_a?(Hash()
        fail("unexpected parameter, expected Hash, received #{params.class}")
      end

      # [GET] /model_pluralized
      # method to recovery all objects from an index
      def all(params = {})
        resource = @@requester.get(to_url, params)
        resource.map do |model|
          array << build(model)
        end
      end

      # [GET] /model_pluralized
      # method to recovery all objects from an index with pagination source
      # `{ objects: [], pagination:  { current_page: page, total_objects: count, per_page: per_page, total_pages: total_pages(per_page) } }`
      def pagination(params = {})
        resource = @@requester.get(to_url, params)
        resource["objects"] = resource["objects"].map do |params|
          resource["objects"] = new(params)
        end
        resource
      end

      # [POST] /model_pluralized
      # method to create an object in the api
      def create(params)
        resource = @@requester.post(to_url, params)
        build(resource)
      end

      # method to call find by attributes
      def find_by(attributes = {}, options = {})
        search = { search: attributes }.merge!(options)
        resource = @@requester.get("#{to_url}/find_by", search)
        resource.map do |element|
          build(element)
        end
      end

      # method to call find by name in the api
      def find_by_name(params)
        resource = @@requester.get("#{to_url}/find_by_name", params)
        resource.map do |model| 
          build(model) 
        end
      end

      # this method recover an object by id
      def find(id, params = {})
        resource = @@requester.get("#{to_url}/#{id}", params)
        build(resource)
      end

      # build the url name for the model
      def to_url
        name.underscore.downcase.pluralize
      end
      
      # build the url name for the model namespace
      def to_param_namespace
        name.downcase
      end
    end
  end
end