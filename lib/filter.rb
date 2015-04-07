require_relative 'matchers/boolean_matcher'
require_relative 'matchers/regexp_matcher'
require_relative 'matchers/string_matcher'
require_relative 'matchers/image_matcher'

module Bengt
  class Filter
    AVAILABLE_FILTERS = %i(title url domain subreddit)

    AVAILABLE_FILTERS.each do |available_filter|
      define_method available_filter do |something|
        if something.is_a?(Regexp)
          @field_matchers[available_filter] = Matchers::RegexpMatcher.new(something)
        elsif something.is_a?(String)
          @field_matchers[available_filter] = Matchers::StringMatcher.new(something)
        end
        self
      end
    end

    def initialize
      @matchers = []
      @field_matchers = {}
    end

    def is_image(boolean)
      @matchers << Matchers::ImageMatcher.new(boolean)
      self
    end

    def is_self(boolean)
      @field_matchers[:is_self] = Matchers::BooleanMatcher.new(boolean)
      self
    end

    def match?(data)
      match_fields?(data) && match_other?(data)
    end

    private

    def match_fields?(data)
      @field_matchers.all? do |key, something|
        something.match?(data.fetch(key.to_s))
      end
    end

    def match_other?(data)
      @matchers.all? do |matcher|
        matcher.match?(data)
      end
    end
  end
end