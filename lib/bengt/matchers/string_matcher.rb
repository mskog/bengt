module Bengt
  module Matchers
    class StringMatcher
      def initialize(filter)
        @filter = filter
      end

      def match?(value)
        value.downcase.include? @filter.downcase
      end
    end
  end
end