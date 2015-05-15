require 'spec_helper'
require 'bengt/models/post'
require 'bengt/decorators/picyo'

describe Bengt::Decorators::Picyo do
  subject{described_class.new(post, configuration_data)}

  Given(:image_url){"http://imgur.com/krDq9fs.jpg"}
  Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json')).merge(image_url: image_url)}
  Given(:post){OpenStruct.new(data)}

  Given(:picyo_url){'http://www.example.com'}
  Given(:picyo_image_url){"#{picyo_url}/api/v1/images"}
  Given(:configuration_data){{url: picyo_url}}

  Given(:picyo_response) do
    {
      image_url: 'http://picyo.com/images/sdofijsdf.jpg',
      width: 576,
      height: 600,
      file_size: 444,
      file_content_type: 'image/jpeg'
    }
  end

  Given{stub_request(:post, picyo_image_url).with(body: {url: image_url}).to_return(body: JSON.generate(picyo_response))}

  describe "Decorated Methods" do
    Then{expect(subject.image_url).to eq picyo_response[:image_url]}
    And{expect(subject.image_width).to eq picyo_response[:width]}
    And{expect(subject.image_height).to eq picyo_response[:height]}
    And{expect(subject.image_size).to eq picyo_response[:file_size]}
    And{expect(subject.image_content_type).to eq picyo_response[:file_content_type]}
  end

  describe "#to_h" do
    When(:result){subject.to_h}
    Then{expect(result[:image_url]).to eq picyo_response[:image_url]}
    And{expect(result[:image_width]).to eq picyo_response[:width]}
    And{expect(result[:image_height]).to eq picyo_response[:height]}
    And{expect(result[:image_size]).to eq picyo_response[:file_size]}
    And{expect(result[:image_content_type]).to eq picyo_response[:file_content_type]}
    And{expect(result[:author]).to eq "BeesKnees33"}
  end
end
