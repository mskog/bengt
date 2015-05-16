require 'virtus'
require 'json'

module Bengt
  module Models
    class Post
      IMAGE_EXTENSIONS = %w(jpg png jpeg gif)


      include Virtus.model

      attribute :id
      attribute :author
      attribute :created_utc
      attribute :domain
      attribute :is_self, Boolean
      attribute :over_18, Boolean
      attribute :image_post, Boolean
      attribute :name
      attribute :permalink
      attribute :selftext
      attribute :subreddit
      attribute :subreddit_id
      attribute :thumbnail
      attribute :title
      attribute :url
      attribute :image_url

      def image_post
        IMAGE_EXTENSIONS.include?(url.split('.').last.downcase)
      end
      alias_method :image_post?, :image_post

      def image_url
        image_post? ? url : ""
      end
    end
  end
end
