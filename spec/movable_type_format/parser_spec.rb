# encoding: UTF-8
require 'spec_helper'

module MovableTypeFormat
  describe Parser do
    before(:all) do
      @mt_string = File.read("#{File.dirname(__FILE__)}/../fixtures/example.movable_type").freeze
    end
    describe "parse" do
      before(:each) do
        @entries = Parser.parse(@mt_string)
      end
      subject { @entries }
      it { should be_a Enumerator }
      it "include two entries" do
        subject.to_a.count.should == 2
      end
      it "include each entry" do
        first, second = subject.to_a
        first.title.should == "A dummy title"
        second.title.should == "Here is a new entry"
      end
      context "first entry" do
        before(:each) do
          @entry = @entries.first
        end
        subject { @entry }
        it { should be_an Entry}
      end
      it "ignore empty line between entries and sections" do
        mt = <<-MT
        TITLE: One
        -----
        BODY:
        Body
        -----

        EXCERPT:
        Excerpt
        -----

        --------
        TITLE: Two
        -----
        BODY:
        Body Two
        -----

        --------
        MT
        mt.gsub!(/^\s+/, "")

        entries = MovableTypeFormat.parse(mt).to_a
        entries.count.should == 2
        one, two = entries
        one.title.should == "One"
        one.body.should == "Body"
        one.excerpt.should == "Excerpt"
        two.title.should == "Two"
        two.body.should == "Body Two"
      end
    end
  end
end
