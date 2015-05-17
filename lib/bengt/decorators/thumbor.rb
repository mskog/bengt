require 'delegate'
require 'ruby-thumbor'

module Bengt
  module Decorators

    # Decorator for a Thumbor service
    # Requires an image_url to be present in the object to be decorated

    # TODO Handle authenticated Thumbor services
    class Thumbor < SimpleDelegator
      include Configuration

      def initialize(object, configuration = {})
        configure(configuration)
        define_singleton_method self.configuration.thumbor_method do
          thumbor_url
        end
        super object
      end

      def to_h
        super.merge(configuration.thumbor_method => thumbor_url)
      end

      private

      def thumbor_url
        crypto = ::Thumbor::CryptoURL.new nil
        thumbor_url = crypto.generate image: __getobj__.image_url, **configuration.thumbor_options
        configuration.url + thumbor_url
      end

      class Configuration
        include Virtus.model

        attribute :url, String, default: ENV['THUMBOR_URL']
        attribute :thumbor_method, String, default: :image_url
        attribute :thumbor_options, Hash
      end
    end
  end
end
