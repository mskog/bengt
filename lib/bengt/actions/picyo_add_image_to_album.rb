module Bengt
  module Actions
    class PicyoAddImageToAlbum
      include Configuration

      def initialize(configuration = {})
        configure(configuration)
      end

      def perform(payload)
        connection = Faraday.new(configuration.url) do |conn|
          conn.request  :url_encoded
          conn.basic_auth(configuration.username, configuration.password)
          conn.adapter :net_http
        end

        response = connection.post("/api/v1/albums/#{configuration.album}/images", {url: payload.image_url})
      end

      private

      class Configuration
        include Virtus.model

        attribute :url, String, default: ENV['PICYO_URL']
        attribute :username, String, default: ENV['PICYO_USERNAME']
        attribute :password, String, default: ENV['PICYO_PASSWORD']
        attribute :album, String, default: ENV['PICYO_ALBUM']
      end
    end
  end
end
