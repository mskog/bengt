require 'pusher'

module Bengt
  module ActionAdapters
    class Pusher
      include Configuration

      def initialize(configuration = {})
        configure(configuration)
      end

      def perform(post)
        pusher_client.trigger(configuration.channel, configuration.event, post.public_send(configuration.payload_method))
      end

      private

      def pusher_client
        @pusher_client ||= ::Pusher::Client::new({
          app_id: configuration.app_id,
          key: configuration.key,
          secret: configuration.secret
        })
      end

      class Configuration
        include Virtus.model

        attribute :app_id, String, default: ENV['PUSHER_APP_ID']
        attribute :key, String, default: ENV['PUSHER_KEY']
        attribute :secret, String, default: ENV['PUSHER_SECRET']

        attribute :channel, String, default: ENV['PUSHER_CHANNEL']

        attribute :event, String, default: :post
        attribute :payload_method, String, default: "to_h"
      end
    end
  end
end
