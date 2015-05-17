require 'spec_helper'
require 'bengt/models/post'

describe Bengt::Models::Post do
  subject{described_class.new(data)}
  Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json'))}

  describe "Attributes" do
    Then{expect(subject.author).to eq 'BeesKnees33'}
    And{expect(subject.created_utc).to eq 1428321961.0}
    And{expect(subject.domain).to eq 'imgur.com'}
    And{expect(subject.id).to eq '31mbii'}
    And{expect(subject.name).to eq "t3_31mbii"}
    And{expect(subject.is_self?).to be_falsy}
    And{expect(subject.over_18?).to be_falsy}
    And{expect(subject.permalink).to eq '/r/pics/comments/31mbii/sunrise_in_cincinnati/'}
    And{expect(subject.selftext).to be_empty}
    And{expect(subject.subreddit).to eq 'pics'}
    And{expect(subject.subreddit_id).to eq 't5_2qh0u'}
    And{expect(subject.thumbnail).to eq 'http://b.thumbs.redditmedia.com/bjcX7-Q1P36IufrxGB0qYDxuYrCOoHzPVlLXgGd6Xmg.jpg'}
    And{expect(subject.title).to eq 'Sunrise in Cincinnati!'}
    And{expect(subject.url).to eq 'http://imgur.com/krDq9fs.jpg'}
  end

  describe "#to_json" do
    When(:result){subject.to_json}
    Then{expect(JSON.parse(result)).to include data}
  end

  describe "Image posts" do
    context "with an image post" do
      Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json'))}
      Then{expect(subject.image_post).to be_truthy}
      And{expect(subject.image_url).to eq subject.url}
    end

    context "with a self post" do
      Given(:data){JSON.parse(File.read('spec/fixtures/selfpost.json'))}
      Then{expect(subject.image_post).to be_falsy}
      And{expect(subject.image_url).to be_empty}
    end
  end
end
