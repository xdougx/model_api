module Statusable
  module ClassMethods
    def define_statuses(*statuses)
      class_eval do
        statuses.each do |status|
          define_method(status) do |url: nil, params: {}, body: {} header: {}|
            url = url.blank? ? "#{to_url}/#{id}/#{status}" : url
            request = requester.new(:get, url, body, params, header)
          end
        end
      end
    end
  end
end