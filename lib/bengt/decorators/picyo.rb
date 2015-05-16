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
        connection = Faraday.new(configuration.url) do |conn|
          conn.request  :url_encoded
          conn.basic_auth(configuration.username, configuration.password)
          conn.adapter :net_http
        end

        response = connection.post("/api/v1/images", {url: __getobj__.image_url})
        JSON.parse(response.body)['image']
      end

      class Configuration
        include Virtus.model

        attribute :url, String, default: ENV['PICYO_URL']
        attribute :username, String, default: ENV['PICYO_USERNAME']
        attribute :password, String, default: ENV['PICYO_PASSWORD']
      end
    end
  end
end
