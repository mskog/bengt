module Bengt
  module Matchers
    class ImageMatcher
      IMAGE_EXTENSIONS = %w(jpg png jpeg gif)
      IMAGE_DOMAINS = %w(imgur.com)

      def initialize(boolean)
        @boolean = boolean
      end

      def match?(data)
        url = data['url']
        image = IMAGE_EXTENSIONS.include?(url.split('.').last.downcase)
        image_domain = IMAGE_DOMAINS.any? do |domain|
          url.downcase.include? domain
        end
        @boolean == (image || image_domain)
      end
    end
  end
end
