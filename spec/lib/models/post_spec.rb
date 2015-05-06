require 'spec_helper'
require 'models/post'

describe Bengt::Models::Post do
  subject{described_class.new()}

  describe "Attributes" do
    Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json'))}
    When(:result){described_class.new(data)}

    Then{expect(result.author).to eq 'BeesKnees33'}
    And{expect(result.created_utc).to eq 1428321961.0}
    And{expect(result.domain).to eq 'imgur.com'}
    And{expect(result.id).to eq '31mbii'}
    And{expect(result.is_self).to be_falsy}
    And{expect(result.name).to eq "t3_31mbii"}
    And{expect(result.over_18).to be_falsy}
    And{expect(result.permalink).to eq '/r/pics/comments/31mbii/sunrise_in_cincinnati/'}
    And{expect(result.selftext).to be_empty}
    And{expect(result.subreddit).to eq 'pics'}
    And{expect(result.subreddit_id).to eq 't5_2qh0u'}
    And{expect(result.thumbnail).to eq 'http://b.thumbs.redditmedia.com/bjcX7-Q1P36IufrxGB0qYDxuYrCOoHzPVlLXgGd6Xmg.jpg'}
    And{expect(result.title).to eq 'Sunrise in Cincinnati!'}
    And{expect(result.url).to eq 'http://imgur.com/krDq9fs.jpg'}
  end
end
