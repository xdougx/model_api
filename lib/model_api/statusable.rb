module Statusable
  module Methods
    def get_status_url(url)
      url.blank? ? "#{to_url}/#{id}/#{status}" : url
    end

    def raise_status_not_found
      fail "Status não definido"
    end

    def request_status_change(url, header)
      request = requester.new(:get, url, {}, {}, header)
      parameters(request.resource)
    end

    def change_status(new_status, url = nil, header = {})
      available_status?(new_status) ? send(new_status, url, header) : raise_status_not_found
    end

  end

  module ClassMethods
    def define_statuses(*statuses)
      statuses.each { |status| define_status_method(status) }
      define_status_check(statuses)
    end
    
    private

    def define_status_method(status)
      class_eval do
        define_method(status) do |url: nil, header: {}|
          request_status_change(get_status_url(url), header)
        end
      end
    end

    def define_status_check(statuses = [])
      class_eval do
        define_method(:available_status?) do |status|
          statuses.include?(status)
        end
      end
    end
  end
end