require 'spec_helper'

describe Bengt::Actions::Pusher do
  Given(:configuration){{
    app_id: 'app_id',
    key: 'key',
    secret: 'secret',
    channel: 'mychannel',
    event: 'iposted'
  }}
  Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json'))}
  Given(:post){Bengt::Models::Post.new(data)}
  subject{described_class.new(configuration)}

  Given(:expected_body) do
    "{\"name\":\"iposted\",\"channels\":[\"mychannel\"],\"data\":\"{\\\"id\\\":\\\"31mbii\\\",\\\"author\\\":\\\"BeesKnees33\\\",\\\"created_utc\\\":1428321961.0,\\\"domain\\\":\\\"imgur.com\\\",\\\"is_self\\\":false,\\\"over_18\\\":false,\\\"image_post\\\":true,\\\"name\\\":\\\"t3_31mbii\\\",\\\"permalink\\\":\\\"/r/pics/comments/31mbii/sunrise_in_cincinnati/\\\",\\\"selftext\\\":\\\"\\\",\\\"subreddit\\\":\\\"pics\\\",\\\"subreddit_id\\\":\\\"t5_2qh0u\\\",\\\"thumbnail\\\":\\\"http://b.thumbs.redditmedia.com/bjcX7-Q1P36IufrxGB0qYDxuYrCOoHzPVlLXgGd6Xmg.jpg\\\",\\\"title\\\":\\\"Sunrise in Cincinnati!\\\",\\\"url\\\":\\\"http://imgur.com/krDq9fs.jpg\\\",\\\"image_url\\\":\\\"http://imgur.com/krDq9fs.jpg\\\"}\"}"
  end

  Given!(:stub) do
    stub_request(:post, /pusherapp/).with(body: expected_body).to_return(body: expected_body)
  end

  When{subject.perform(post)}

  Then{expect(stub).to have_been_requested}
end
