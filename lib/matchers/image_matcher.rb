module Bengt
  module Matchers
    class ImageMatcher
      IMAGE_EXTENSIONS = %w(jpg png jpeg gif)

      def initialize(boolean)
        @boolean = boolean
      end

      def match?(data)
        @boolean == (IMAGE_EXTENSIONS.include? data['url'].split('.').last.downcase)
      end
    end
  end
end