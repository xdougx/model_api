module Relations

  module ClassMethods
    def belongs_to(relation_name, options = {})
      klass = get_relation_class(options)
      
      class_eval do
        define_setter(relation_name, klass)
        define_getter(relation_name, klass)
      end

      private 

      def define_setter(relation_name, klass)
        define_method("#{relation_name}=", args) do
          instance_variable_set(relation_name, klass.build(args))
        end
      end

      def define_getter(relation_name, klass)
        define_method(relation_name) do
          instance_variable_get(:"@#{relation_name}") || klass.new
        end
      end

      def get_relation_class(options = {})
        klass = options[:class_name] ? options[:class_name] : relation_name.camelize
        defined?(klass) ? klass.constantize : raise_class_not_defined(klass)
      end

      def raise_class_not_defined(klass)
        fail "#{klass} isn't defined"
      end

    end
  end
end