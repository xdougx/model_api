module ModelApi
  class Base 
    include ActiveModel::Model
    include Requester
    include Header

    @@requester = ModelApi::Requester
    @@page_size = 20
  
    def initialize(params = {})
      set_parameters(params)
    end

    # converte o model object para um json sem os valores null
    # @param [Hash] options
    # @return [String]
    def to_json(options = {})
      self.serializable_hash.compact.to_json(options)
    end

    # seta os parametros passo para a classe
    # @param [Hash] params
    def set_parameters(params)
      params.each do |key, value|
        self.send("#{key}=".to_sym, value) if self.respond_to? key
      end
    end
    
    # PUT    /v1/models/:id   controller#update
    # atualiza um objeto persistido na api
    # @param [Hash] params
    def update(params)
      resource = @@requester.put(("#{to_url}/#{id}"), params)
      set_parameters(resource)
    end

    # PUT    /v1/models/:model_id/archive  controller#archive
    # atualiza o status do objeto para 'archived'
    # @param [Hash] params
    def archive(params)
      resource = @@requester.put("#{to_url}/#{id}/archive"), params)
      set_parameters resource
    end

    # PUT    /v1/models/:model_id/active   controller#active
    # atualiza o status do objeto para 'active'
    def active(params)
      resource = @@requester.put("#{to_url}/#{id}/active"), params)
      set_parameters(resource)
    end

    # verifica se o objeto está ativo se tiver o attributo status
    # @return [Boolean]
    def active?
      if self.respond_to? :status
        self.status == 'active'
      end
    end

    # cria o nome da classe em formato de url
    def to_url
      self.class.name.underscore.downcase.pluralize
    end

    # cria o nome da classe em formato de namespace para os parametros da url
    def to_param_namespace
      self.class.name.underscore.downcase
    end

    class << self
      # metodo que cria um objeto e seta os seus parametros se responder pela chave
      # recebe um Hash como parametro
      def build(params)
        return new(params) if params.is_a?(Hash()
        fail("unexpected parameter, expected Hash, received #{params.class}")
      end

      # GET  /v1/models   controller#index
      # recupera todos os elementos de um determinado resource na API
      def all(params = {})
        resource = @@requester.get(to_url, params)
        resource.map do |model|
          array << build(model)
        end
      end

      def page_size options = {}
        options[:index_size] = 'true'
        resource = @@requester.get(to_url, options)
        size = (resource["size"].to_f / PAGE_SIZE.to_f).ceil
        size = 1 if size <= 1
        size      
      end

      def page_length options = {}
        options.merge!(index_size: 'true')
        resource = @@requester.get(to_url, options)
        resource["size"]
      end

      def where(filters = {})
      end

      # POST   /v1/models  controller#create
      # cria um novo objeto persistido pela api
      # @param [Hash] params
      def create(params)
        resource = @@requester.post(to_url, params)
        valid_response?(resource)
        build(resource)
      end

      def find_by(attributes = {}, options = {})
        search = { search: attributes }.merge!(options)
        resource = @@requester.get("#{to_url}/find_by", search)
        resource.map do |element|
          build(element)
        end
      end

      def find_by_name(params)
        resource = @@requester.get("#{to_url}/find_by_name", params)
        resource.map do |model| 
          build(model) 
        end
      end

      # metodo que recupera um objeto na api a partir de um id existente
      # @param [Integer] id
      # @return [ModelBase]
      def find(id, params = {})
        resource = @@requester.get("#{to_url}/#{id}", params)
        valid_response?(resource)
        build(resource)
      end

      # cria o nome da classe em formato de url
      def to_url
        name.underscore.downcase.pluralize
      end
      
      # cria o nome da classe em formato de namespace para os parametros da url
      def to_param_namespace
        name.downcase
      end
    end
  end
end