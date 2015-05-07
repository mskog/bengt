require 'slack-notifier'

module Bengt
  module ActionAdapters
    class Slack
      include Configuration

      def initialize(configuration = {})
        configure(configuration)
      end

      def perform(payload)
        ::Slack::Notifier.new(configuration.url, configuration.options).ping payload[:url].to_s
      end

      class Configuration
        include Virtus.model

        attribute :url

        attribute :username
        attribute :channel

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
