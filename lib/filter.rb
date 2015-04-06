require 'matchers/boolean_matcher'
require 'matchers/regexp_matcher'
require 'matchers/string_matcher'

module Bengt
  class Filter
    AVAILABLE_FILTERS = %i(title url domain subreddit)

    AVAILABLE_FILTERS.each do |available_filter|
      define_method available_filter do |something|
        if something.is_a?(Regexp)
          @matchers[available_filter] = Matchers::RegexpMatcher.new(something)
        elsif something.is_a?(String)
          @matchers[available_filter] = Matchers::StringMatcher.new(something)
        end
        self
      end
    end

    def initialize
      @matchers = {}
    end

    def is_self(boolean)
      @matchers[:is_self] = Matchers::BooleanMatcher.new(boolean)
    end

    def match?(data)
      @matchers.all? do |key, something|
        something.match?(data.fetch(key.to_s))
      end
    end
  end
end