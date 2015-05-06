require 'json'

module Bengt
  module Models
    class Post
      include Virtus.model

      attribute :id
      attribute :author
      attribute :created_utc
      attribute :domain
      attribute :is_self, Boolean
      attribute :over_18, Boolean
      attribute :name
      attribute :permalink
      attribute :selftext
      attribute :subreddit
      attribute :subreddit_id
      attribute :thumbnail
      attribute :title
      attribute :url
    end
  end
end
