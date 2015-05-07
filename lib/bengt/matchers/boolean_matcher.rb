module Bengt
  module Matchers
    class BooleanMatcher
      def initialize(filter)
        @filter = filter
      end

      def match?(value)
        @filter == value
      end
    end
  end
end