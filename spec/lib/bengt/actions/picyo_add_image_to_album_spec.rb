require 'spec_helper'

describe Bengt::Actions::PicyoAddImageToAlbum do
  Given(:picyo_url){'http://www.example.com'}
  Given(:configuration){{url: picyo_url, email: email, token: token, album: 'foobar'}}

  Given(:email){'test@example.com'}
  Given(:token){'token'}
  Given(:picyo_url){"http://www.example.com"}

  When{subject.perform(post)}

  context "simple" do
    Given(:image_url){"http://www.example.com/example.png"}
    Given(:post){OpenStruct.new(image_url: image_url)}
    subject{described_class.new(configuration)}

    Given(:expected_headers) do
      {
        'X-User-Email' => email,
        'X-User-Token' => token,
      }
    end

    Given!(:stub) do
      stub_request(:post, "#{picyo_url}/api/v1/albums/#{configuration[:album]}/images").with(headers: (expected_headers), body: {url: image_url, async: '1'})
    end

    Then{expect(stub).to have_been_requested}
  end

  context "with an image type filter" do
    Given(:image_url){"http://www.example.com/example.png"}
    Given(:post){OpenStruct.new(image_url: image_url)}
    subject{described_class.new(configuration)}

    Given(:image_types){['gif', 'jpg']}
    Given(:configuration){{url: picyo_url, email: email, token: token, album: 'foobar', image_types: image_types}}
    Given!(:stub){stub_request(:post, /#{picyo_url}/)}
    Then{expect(stub).to_not have_been_requested}
  end
end
