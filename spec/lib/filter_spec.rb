require 'spec_helper'
require 'json'
require 'filter'

describe Bengt::Filter do
  subject{described_class.new}

  context "an imgur gallery" do
    Given(:data){JSON.parse(File.read('spec/fixtures/imgur_gallery.json'))}

    context "Filtering on title" do
      Given{subject.title(title)}
      When(:result){subject.match?(data)}

      context "with a matching regexp" do
        Given(:title){/journey/i}
        Then{expect(result).to be_truthy}
      end

      context "with a regexp that doesn't match" do
        Given(:title){/foobar/i}
        Then{expect(result).to be_falsy}
      end

      context "with a string that is included in the title" do
        Given(:title){'journey'}
        Then{expect(result).to be_truthy}
      end

      context "with a string that is not included in the title" do
        Given(:title){'foobar'}
        Then{expect(result).to be_falsy}
      end
    end

    context "Filtering on url" do
      Given{subject.url(url)}
      When(:result){subject.match?(data)}

      context "with a matching regexp" do
        Given(:url){/gallery/i}
        Then{expect(result).to be_truthy}
      end

      context "with a regexp that doesn't match" do
        Given(:url){/foobar/i}
        Then{expect(result).to be_falsy}
      end

      context "with a string that is included in the url" do
        Given(:url){'gallery'}
        Then{expect(result).to be_truthy}
      end

      context "with a string that is not included in the url" do
        Given(:url){'foobar'}
        Then{expect(result).to be_falsy}
      end
    end

    context "Filtering on is_self" do
      When(:result){subject.match?(data)}

      context "with a self post" do
        Given(:data){JSON.parse(File.read('spec/fixtures/selfpost.json'))}

        context "with a filter matching on NOT selfposts" do
          Given{subject.is_self(false)}
          Then{expect(subject.match?(data)).to be_falsy}
        end

        context "with a filter matching on selfposts" do
          Given{subject.is_self(true)}
          Then{expect(subject.match?(data)).to be_truthy}
        end
      end

      context "with a link post" do
        Given(:data){JSON.parse(File.read('spec/fixtures/imgur_gallery.json'))}

        context "with a filter matching on NOT selfposts" do
          Given{subject.is_self(false)}
          Then{expect(subject.match?(data)).to be_truthy}
        end

        context "with a filter matching on selfposts" do
          Given{subject.is_self(true)}
          Then{expect(subject.match?(data)).to be_falsy}
        end
      end
    end
  end
end