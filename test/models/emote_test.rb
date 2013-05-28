require 'test_helper'

describe Emote do
  before do
    @emote = Emote.new
  end

  it "should respond to it's attributes" do
    attrs = [:text, :description, :text_rows, :longest_line_length, :tags]
    attrs.each do |attr|
      @emote.must_respond_to attr
    end
  end

  it "should calculate the longest line length when text is assigned" do
    @emote.text = "foobar"
    @emote.longest_line_length.must_equal 6
    @emote.text = "foobar\nfoobaz7\nfoo"
    @emote.longest_line_length.must_equal 7
  end

  it "should calculate the row count when text is set" do
    @emote.text = "foobar"
    @emote.text_rows.must_equal 1
    @emote.text = "foobar\nfoobaz7\nfoo"
    @emote.text_rows.must_equal 3
  end

  it "should allow saving of tags as a ruby array" do
    @emote.tags = [:foo, :bar, :baz]
    @emote.tags.must_be_instance_of Array
  end

  it "should only be valid with text set" do
    @emote.valid?.must_equal false
    @emote.text = "foobar"
    @emote.valid?.must_equal true
  end
end