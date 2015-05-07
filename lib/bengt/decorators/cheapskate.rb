require 'delegate'

module Bengt
  module Decorators
    class Cheapskate < SimpleDelegator
      include Configuration

      def initialize(object, configuration = {})
        configure(configuration)
        super object
      end

      def body
        cheapskate_data['body']
      end

      def image_url
        cheapskate_data['top_image']
      end

      def to_h
        super.merge(body: body, image_url: image_url)
      end

      class Configuration
        include Virtus.model

        attribute :url
      end

      private

      def details_url
        "#{configuration.url}/details"
      end

      def cheapskate_data
        @cheapskate_data ||= fetch_data
      end

      def fetch_data
        response = Faraday.get(details_url) do |faraday|
          faraday.params['url'] = url
        end
        JSON.parse(response.body)
      end
    end
  end
end
