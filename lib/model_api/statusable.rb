module Statusable
  module Methods
    def get_status_url(url, sts_method)
      url.blank? ? "#{to_url}/#{id}/#{sts_method}" : url
    end

    def raise_status_not_found
      fail "Status não definido"
    end

    def request_status_change(url, header)
      request = requester.new(:get, url, {}, {}, header)
      parameters(request.resource)
    end

    def change_status(new_status, url = nil, header = {})
      if available_status?(new_status)
        request_status_change(get_status_url(url, new_status)l, header)
      else
        raise_status_not_found
      end
    end

  end

  module ClassMethods
    def define_statuses(*statuses)
      statuses.each { |sts_method| define_status_method(sts_method) }
      define_status_check(statuses)
    end
    
    private

    def define_status_method(sts_method)
      class_eval do
        define_method(sts_method.to_sym) do |url: nil, header: {}|
          request_status_change(get_status_url(url, sts_method), header)
        end
      end
    end

    def define_status_check(statuses = [])
      class_eval do
        define_method(:available_status?) do |sts_method|
          statuses.include?(sts_method)
        end
      end
    end
  end
end