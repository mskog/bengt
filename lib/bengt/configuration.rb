module Bengt
  module Configuration
    def self.included(base)
      base.extend ClassMethods
    end

    def configuration
      klass = self.class
      @configuration ||= (klass.configuration_klass || klass::Configuration).new
    end

    def configure(data = {}, &block)
      configuration.attributes = data
      yield configuration if block_given?
    end

    module ClassMethods
      attr_reader :configuration_klass

      def configured_with(klass)
        @configuration_klass = klass
      end
    end
  end
end
