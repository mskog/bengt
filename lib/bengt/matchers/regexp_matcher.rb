module Bengt
  module Matchers
    class RegexpMatcher
      def initialize(filter)
        @filter = filter
      end

      def match?(value)
        @filter =~ value
      end
    end
  end
end