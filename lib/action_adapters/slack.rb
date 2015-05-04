require 'slack-notifier'
require 'virtus'

module Bengt
  module ActionAdapters
    class Slack
      def initialize(configuration = {})
        configure(configuration)
      end

      def configuration
        @configuration ||= Configuration.new
      end

      def configure(data = {}, &block)
        configuration.attributes = data
        yield configuration if block_given?
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
