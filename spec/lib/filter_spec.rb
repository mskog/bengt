require 'spec_helper'
require 'json'
require 'filter'

describe Bengt::Filter do
  subject{described_class.new}

  describe "Initializing from a hash" do
    subject{described_class.from_hash(filter)}
    Given(:data){JSON.parse(File.read('spec/fixtures/imgur_gallery.json'))}

    context "with a matching filter" do
      Given(:filter){{is_self: false, title: 'journey'}}
      Then{expect(subject.match?(data)).to be_truthy}
    end

    context "with a filter that doesn't match" do
      Given(:filter){{is_self: false, title: 'journey2'}}
      Then{expect(subject.match?(data)).to be_falsy}
    end

    context "with a filter that matches the title but not is_self" do
      Given(:filter){{is_self: true, title: 'journey'}}
      Then{expect(subject.match?(data)).to be_falsy}
    end
  end

  context "an imgur gallery" do
    Given(:data){JSON.parse(File.read('spec/fixtures/imgur_gallery.json'))}

    context "Filtering on title" do
      Given{subject.title(title)}
      When(:result){subject.match?(data)}

      describe "it returns self" do
        Then{expect(subject.title('foobar')).to eq subject}
      end

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

      describe "it returns self" do
        Then{expect(subject.is_self(false)).to eq subject}
      end

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

    context "Filtering on is_image" do
      When(:result){subject.match?(data)}

      describe "it returns self" do
        Then{expect(subject.is_image(false)).to eq subject}
      end

      context "with an image post" do
        Given(:data){JSON.parse(File.read('spec/fixtures/imagepost.json'))}

        context "filtering on is_image true" do
          Given{subject.is_image(true)}
          Then{expect(result).to be_truthy}
        end

        context "filtering on is_image false" do
          Given{subject.is_image(false)}
          Then{expect(result).to be_falsy}
        end

      end

      context "with a non image post" do
        Given(:data){JSON.parse(File.read('spec/fixtures/selfpost.json'))}

        context "filtering on is_image true" do
          Given{subject.is_image(true)}
          Then{expect(result).to be_falsy}
        end

        context "filtering on is_image false" do
          Given{subject.is_image(false)}
          Then{expect(result).to be_truthy}
        end
      end
    end

    context "Filtering on over_18" do
      When(:result){subject.match?(data)}

      describe "it returns self" do
        Then{expect(subject.over_18(false)).to eq subject}
      end

      context "with an adult post" do
        Given(:data){JSON.parse(File.read('spec/fixtures/adultpost.json'))}

        context "filtering on is_image true" do
          Given{subject.over_18(true)}
          Then{expect(result).to be_truthy}
        end

        context "filtering on over_18 false" do
          Given{subject.over_18(false)}
          Then{expect(result).to be_falsy}
        end
      end

      context "with a non adult post" do
        Given(:data){JSON.parse(File.read('spec/fixtures/selfpost.json'))}

        context "filtering on over_18 true" do
          Given{subject.over_18(true)}
          Then{expect(result).to be_falsy}
        end

        context "filtering on over_18 false" do
          Given{subject.over_18(false)}
          Then{expect(result).to be_truthy}
        end
      end
    end

  end
end
