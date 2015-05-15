require 'delegate'

module Bengt
  module Decorators

    # Decorator for the Picyo image hosting project
    # Requires an image_url to be present in the object to be decorated
    class Picyo < SimpleDelegator
      include Configuration

      def initialize(object, configuration = {})
        configure(configuration)
        super object
      end

      def image_url
        picyo_data["image_url"]
      end

      def image_width
        picyo_data["width"]
      end

      def image_height
        picyo_data["height"]
      end

      def image_size
        picyo_data["file_size"]
      end

      def image_content_type
        picyo_data["file_content_type"]
      end

      def to_h
        super.merge(image_url: image_url, image_height: image_height, image_width: image_width, image_size: image_size, image_content_type: image_content_type)
      end

      private

      def picyo_data
        @picyo_data ||= fetch_data
      end

      def fetch_data
        response = Faraday.get(images_url) do |faraday|
          faraday.params['url'] = __getobj__.image_url
        end
        JSON.parse(response.body)
      end

      def images_url
        "#{configuration.url}/images"
      end

      class Configuration
        include Virtus.model

        attribute :url, String, default: ENV['PICYO_URL']
      end
    end
  end
end
