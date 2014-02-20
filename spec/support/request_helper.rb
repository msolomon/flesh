module Requests
  module JsonHelpers
    def get_json
      @json ||= JSON.parse(response.body)
    end
  end
end
