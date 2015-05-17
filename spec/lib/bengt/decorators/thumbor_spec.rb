require 'spec_helper'
require 'bengt/models/post'
require 'bengt/decorators/thumbor'

describe Bengt::Decorators::Thumbor do
  Given(:post){Bengt::Models::Post.new(data)}
  Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json'))}

  subject{described_class.new(post, configuration_data)}

  context "with a Thumbor endpoint with unsafe on" do
    Given(:thumbor_url){'http://www.example.com'}
    Given(:configuration_data){{url: thumbor_url, thumbor_options: thumbor_options}}
    Given(:expected_url){"#{thumbor_url}/unsafe/300x200/smart/#{post.image_url}"}
    Given(:thumbor_options){{width: 300, height: 200, smart: true}}

    context "with the default method" do
      Then{expect(subject.image_url).to eq expected_url}
      And{expect(subject.to_h.fetch('image_url')).to eq expected_url}
    end

    context "with a custom method" do
      Given(:configuration_data){{url: thumbor_url, thumbor_method: :thumbnail_url, thumbor_options: thumbor_options}}
      Then{expect(subject.thumbnail_url).to eq expected_url}
      And{expect(subject.to_h).to include("thumbnail_url" => expected_url)}
    end
  end
end
