require 'spec_helper'

describe Bengt::Actions::Slack do
  subject{described_class.new}

  Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json'))}
  Given(:post){Bengt::Models::Post.new(data)}

  describe "#perform" do
    context "with configuration from hash in the initializer" do
      Given(:url){'http://www.example.com/'}
      Given(:username){'foobar'}
      Given(:channel){'#default'}
      Given!(:stub){stub_request(:post, url).with(:body => {"payload"=>"{\"channel\":\"#default\",\"username\":\"foobar\",\"text\":\"#{payload}\"}"})}
      Given(:payload){'http://imgur.com/krDq9fs.jpg'}

      subject{described_class.new(url: url, username: username, channel: channel)}

      When{subject.perform(post)}

      Then{expect(stub).to have_been_requested}
    end

    context "with configuration from hash" do
      Given(:url){'http://www.example.com/'}
      Given(:username){'foobar'}
      Given(:channel){'#default'}
      Given!(:stub){stub_request(:post, url).with(:body => {"payload"=>"{\"channel\":\"#default\",\"username\":\"foobar\",\"text\":\"#{payload}\"}"})}
      Given(:payload){'http://imgur.com/krDq9fs.jpg'}

      Given{subject.configure(url: url, username: username, channel: channel)}

      When{subject.perform(post)}

      Then{expect(stub).to have_been_requested}
    end

    context "with block configuration" do
      Given(:url){'http://www.example.com/'}
      Given!(:stub){stub_request(:post, url).with(:body => {"payload"=>"{\"text\":\"#{payload}\"}"})}
      Given(:payload){'http://imgur.com/krDq9fs.jpg'}

      Given do
        subject.configure do |config|
          config.url = url
        end
      end

      When{subject.perform(post)}

      Then{expect(stub).to have_been_requested}
    end

    context "with a custom method" do
      Given(:url){'http://www.example.com/'}
      Given(:username){'foobar'}
      Given(:channel){'#default'}
      Given!(:stub){stub_request(:post, url).with(:body => {"payload"=>"{\"channel\":\"#default\",\"username\":\"foobar\",\"text\":\"#{payload}\"}"})}
      Given(:payload){"/r/pics/comments/31mbii/sunrise_in_cincinnati/"}

      subject{described_class.new(url: url, username: username, channel: channel, payload_method: :permalink)}

      When{subject.perform(post)}

      Then{expect(stub).to have_been_requested}

    end
  end
end
