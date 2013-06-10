class Emote < ActiveRecord::Base
  validates :text, presence: true, uniqueness: true

  # Make sure the text numerics are assigned properly and display row/columns are calculated once
  before_create :calculate_display_columns
  before_create :calculate_display_rows

  before_save  :assign_text_numeric_vals

  scope :all_tags, -> (tags) { where("tags ?& ARRAY[:tags]", tags: tags) }
  scope :any_tags, -> (tags) { where("tags ?| ARRAY[:tags]", tags: tags) }

  def assign_text_numeric_vals
    self.text_rows  = calc_text_rows(text)
    self.max_length = calc_max_length(text)
  end

  private

  def calc_max_length(text)
    return nil if text.nil?
    lines = text.lines.map(&:chomp)
    lines.collect do |l|
      ActiveSupport::Multibyte::Chars.new(l).normalize(:c).length
    end.max
  end

  def calc_text_rows(text)
    return nil if text.nil?
    text.lines.map(&:chomp).count
  end

  def calculate_display_columns
    self.display_columns = 1
  end

  def calculate_display_rows
    self.display_rows = 1
  end
end
