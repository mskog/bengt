require 'spec_helper'
require 'bengt/action_adapters/slack'

describe Bengt::ActionAdapters::Slack do
  subject{described_class.new}

  describe "#perform" do
    context "with configuration from hash in the initializer" do
      Given(:url){'http://www.example.com/'}
      Given(:username){'foobar'}
      Given(:channel){'#default'}
      Given!(:stub){stub_request(:post, url).with(:body => {"payload"=>"{\"channel\":\"#default\",\"username\":\"foobar\",\"text\":\"http://www.cnn.com\"}"})}
      Given(:payload){{url: :'http://www.cnn.com'}}

      subject{described_class.new(url: url, username: username, channel: channel)}

      When{subject.perform(payload)}

      Then{expect(stub).to have_been_requested}
    end

    context "with configuration from hash" do
      Given(:url){'http://www.example.com/'}
      Given(:username){'foobar'}
      Given(:channel){'#default'}
      Given!(:stub){stub_request(:post, url).with(:body => {"payload"=>"{\"channel\":\"#default\",\"username\":\"foobar\",\"text\":\"http://www.cnn.com\"}"})}
      Given(:payload){{url: :'http://www.cnn.com'}}

      Given{subject.configure(url: url, username: username, channel: channel)}

      When{subject.perform(payload)}

      Then{expect(stub).to have_been_requested}
    end

    context "with block configuration" do
      Given(:url){'http://www.example.com/'}
      Given!(:stub){stub_request(:post, url).with(:body => {"payload"=>"{\"text\":\"http://www.cnn.com\"}"})}
      Given(:payload){{url: :'http://www.cnn.com'}}

      Given do
        subject.configure do |config|
          config.url = url
        end
      end

      When{subject.perform(payload)}

      Then{expect(stub).to have_been_requested}
    end
  end
end
