module Statusable
  module Methods
    def get_status_url(url, sts_method)
      url.blank? ? "#{to_url}/#{id}/#{sts_method}" : url
    end

    def get_collection_url(url, method_pluralized)
      url.blank? ? "#{to_url}/#{method_pluralized}" : url
    end

    def raise_status_not_found
      fail "Status não definido"
    end

    def request_status_change(url, header)
      request = requester.new(:get, url, {}, {}, header)
      parameters(request.resource)
    end

    def request_collection(url, params, header)
      request = requester.new(:get, url, {}, params, header)
      request.resource['objects'] = request.resource['objects'].map { |param| build(param) }
      request.resource
    end

    def change_status(new_status, url = nil, header = {})
      if available_status?(new_status)
        url = get_status_url(url, new_status)
        request_status_change(url, header)
      else
        raise_status_not_found
      end
    end

  end

  module ClassMethods
    def define_statuses(*statuses)
      class_eval do
        statuses.each { |sts_method| define_status_method(sts_method) }
        statuses.each { |sts_method| define_collection_method(sts_method.pluralize) }
        define_status_check(statuses)
      end
    end
    
    private

    def define_status_method(sts_method)
      define_method(sts_method.to_sym) do |url: nil, header: {}|
        request_status_change(get_status_url(url, sts_method), header)
      end
    end

    def define_collection_method(method_pluralized)
      define_method(method_pluralized) do |url: nil, param: {}, header: {}|
        request_collection(get_collection_url(url, method_pluralized), param, header)
      end
    end

    def define_status_check(statuses = [])
      define_method(:available_status?) do |sts_method|
        statuses.include?(sts_method)
      end
    end
  end
end