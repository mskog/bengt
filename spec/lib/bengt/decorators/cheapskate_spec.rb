require 'spec_helper'
require 'bengt/models/post'
require 'bengt/decorators/cheapskate'

describe Bengt::Decorators::Cheapskate do
  subject{described_class.new(post, configuration_data)}

  Given(:post){Bengt::Models::Post.new(data)}

  Given(:cheapskate_top_image){'http://www.example.com/image.jpg'}
  Given(:cheapskate_body){'foo bar'}
  Given(:cheapskate_data){{body: cheapskate_body, top_image: cheapskate_top_image}}

  Given(:cheapskate_url){'http://www.example.com'}
  Given(:details_url){"#{cheapskate_url}/details?url=#{post.url}"}
  Given(:configuration_data){{url: cheapskate_url}}

  context "with a post that is not an image" do
    Given(:data){JSON.parse(File.read('spec/fixtures/imgur_gallery.json'))}
    Given{stub_request(:get, details_url).to_return(body: JSON.generate(cheapskate_data))}

    describe "#body" do
      When(:result){subject.body}
      Then{expect(result).to eq cheapskate_body}
    end

    describe "#image_url" do
      When(:result){subject.image_url}
      Then{expect(result).to eq cheapskate_top_image}
    end

    describe "#to_h" do
      When(:result){subject.to_h}
      Then{expect(result[:body]).to eq cheapskate_body}
      And{expect(result[:image_url]).to eq cheapskate_top_image}
      And{expect(result[:author]).to eq "PXLFLX"}
    end
  end

  context "with an image post" do
    Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json'))}

    describe "#body" do
      When(:result){subject.body}
      Then{expect(result).to eq ''}
    end

    describe "#image_url" do
      When(:result){subject.image_url}
      Then{expect(result).to eq post.image_url}
    end

    describe "#to_h" do
      When(:result){subject.to_h}
      Then{expect(result[:body]).to eq ""}
      And{expect(result[:image_url]).to eq post.image_url}
      And{expect(result[:author]).to eq "BeesKnees33"}
    end
  end
end
