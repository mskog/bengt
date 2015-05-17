require 'slack-notifier'

module Bengt
  module ActionAdapters
    class Slack
      include Configuration

      def initialize(configuration = {})
        configure(configuration)
      end

      def perform(payload)
        ::Slack::Notifier.new(configuration.url, configuration.options).ping payload.public_send(configuration.payload_method).to_s
      end

      class Configuration
        include Virtus.model

        attribute :url, String, default: ENV['SLACK_URL']

        attribute :username, String, default: ENV['SLACK_USERNAME']
        attribute :channel, String, default: ENV['SLACK_CHANNEL']
        attribute :payload_method, String, default: 'url'

        def options
          [:channel, :username].each_with_object({}) do |attribute, object|
            data = send(attribute)
            object[attribute] = data if data
          end
        end
      end
    end
  end
end
