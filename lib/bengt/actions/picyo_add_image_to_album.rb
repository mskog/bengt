module Bengt
  module Actions
    class PicyoAddImageToAlbum
      include Configuration

      DEFAULT_IMAGE_TYPES = ['jpg', 'gif', 'jpeg', 'png']

      def initialize(configuration = {})
        configure(configuration)
      end

      def perform(payload)
        return unless allowed_image_type?(payload.image_url)
        connection = Faraday.new(configuration.url) do |conn|
          conn.request  :url_encoded
          conn.basic_auth(configuration.username, configuration.password)
          conn.adapter :net_http
        end

        response = connection.post("/api/v1/albums/#{configuration.album}/images", {url: payload.image_url})
      end

      private

      def allowed_image_type?(image_url)
        configuration.image_types.include? image_url.split('.').last
      end

      class Configuration
        include Virtus.model

        attribute :url, String, default: ENV['PICYO_URL']
        attribute :username, String, default: ENV['PICYO_USERNAME']
        attribute :password, String, default: ENV['PICYO_PASSWORD']
        attribute :album, String, default: ENV['PICYO_ALBUM']
        attribute :image_types, Array, default: DEFAULT_IMAGE_TYPES
      end
    end
  end
end
