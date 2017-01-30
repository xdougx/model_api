module Statusable
  module ClassMethods
    
    def define_statuses(*statuses)
      statuses.each { |status| define_status_method(status) }
    end
    
    private

    def define_status_method(status)
      class_eval do
        define_method(status) do |url: nil, header: {}|
          request_status_change(get_status_url(url), header)
        end
      end
    end

    def get_status_url(url)
      url.blank? ? "#{to_url}/#{id}/#{status}" : url
    end

    def request_status_change(url, header)
      request = requester.new(:get, url, {}, {}, header)
      parameters(request.resource)
    end

  end
end