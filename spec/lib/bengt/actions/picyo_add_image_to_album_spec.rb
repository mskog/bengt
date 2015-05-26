require 'spec_helper'

describe Bengt::Actions::PicyoAddImageToAlbum do
  Given(:picyo_url){'http://www.example.com'}
  Given(:configuration){{url: picyo_url, username: 'username', password: 'password', album: 'foobar'}}

  Given(:username){'username'}
  Given(:password){'password'}
  Given(:picyo_url){"http://www.example.com"}
  Given(:authenticated_url){"http://#{username}:#{password}@www.example.com"}

  When{subject.perform(post)}
  context "simple" do
    Given(:image_url){"http://www.example.com/example.png"}
    Given(:post){OpenStruct.new(image_url: image_url)}
    subject{described_class.new(configuration)}

    Given!(:stub) do
      stub_request(:post, "#{authenticated_url}/api/v1/albums/#{configuration[:album]}/images").with(body: {url: image_url})
    end

    Then{expect(stub).to have_been_requested}
  end

  context "with an image type filter" do
    Given(:image_url){"http://www.example.com/example.png"}
    Given(:post){OpenStruct.new(image_url: image_url)}
    subject{described_class.new(configuration)}

    Given(:image_types){['gif', 'jpg']}
    Given(:configuration){{url: picyo_url, username: 'username', password: 'password', album: 'foobar', image_types: image_types}}
    Given!(:stub){stub_request(:post, /#{authenticated_url}/)}
    Then{expect(stub).to_not have_been_requested}
  end
end
