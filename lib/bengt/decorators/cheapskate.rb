require 'delegate'

module Bengt
  module Decorators

    # TODO It is unnecessary to perform a request to Cheapskate to decorate this if the url for the post is already an image
    class Cheapskate < SimpleDelegator
      include Configuration

      def initialize(object, configuration = {})
        configure(configuration)
        super object
      end

      def body
        data['body']
      end

      def image_url
        data['top_image']
      end

      def to_h
        super.merge(body: body, image_url: image_url)
      end

      private

      def details_url
        "#{configuration.url}/details"
      end

      def data
        if self.image_post?
          @data ||= {"body" => '', "top_image" => __getobj__.image_url}
        else
          @data ||= fetch_data
        end
      end

      def fetch_data
        response = Faraday.get(details_url) do |faraday|
          faraday.params['url'] = url
        end
        JSON.parse(response.body)
      end

      class Configuration
        include Virtus.model

        attribute :url, String, default: ENV['CHEAPSKATE_URL']
      end
    end
  end
end
