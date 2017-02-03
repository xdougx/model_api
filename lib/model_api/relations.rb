# Relations module will build up attr_acessor for relations
module Relations
  # Relations module will build up attr_acessor for relations
  module ClassMethods
    def belongs_to(relation_name, options = {})
      klass = get_relation_class(relation_name, options)
      
      class_eval do
        define_setter(relation_name, klass)
        define_getter(relation_name, klass)
        define_namespace(relation_name.to_s) if options[namespace]
      end
    end

    def has_many(relation_name, options = {})
      klass = get_relation_class(relation_name, options)
      
      class_eval do
        define_many_setter(relation_name, klass)
        define_many_getter(relation_name, klass)
      end
    end

    private 

    def define_many_setter(relation_name, klass)
      define_method("#{relation_name}=") do |args|
        if args.is_a?(Array) && args.any?
          builded = args.map { |param| klass.build(param) }
          instance_variable_set("@#{relation_name}", builded)
        else
          instance_variable_set("@#{relation_name}", [])
        end
      end
    end

    def define_many_getter(relation_name, _klass)
      define_method(relation_name) do 
        # TODO Implement Lazyload
        # list = instance_variable_get(:"@#{relation_name}")
        # list.empty? ? lazy_load(klass, self) : list
        instance_variable_get(:"@#{relation_name}")
      end
    end

    def define_namespace(relation_name)
      define_method(:to_url) do
        namespace_id = send("#{relation_name}_id")
        "#{relation_name.pluralize}/#{namespace_id}/#{super}"
      end
    end

    def define_setter(relation_name, klass)
      define_method("#{relation_name}=") do |args|
        instance_variable_set("@#{relation_name}", klass.build(args))
      end
    end

    def define_getter(relation_name, klass)
      define_method(relation_name) do 
        instance_variable_get(:"@#{relation_name}") || klass.new
      end
    end

    def get_relation_class(relation_name, options = {})
      klass = options[:class_name] ? options[:class_name] : relation_name.to_s.camelize.singularize
      defined?(klass) ? klass.constantize : raise_class_not_defined(klass)
    end

    def raise_class_not_defined(klass)
      fail "#{klass} isn't defined"
    end
  end
end