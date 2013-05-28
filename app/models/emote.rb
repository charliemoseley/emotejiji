class Emote < ActiveRecord::Base
  validates :text, presence: true, uniqueness: true

  def text=(text)
    super
    self.text_rows           = calc_text_rows(text)
    self.longest_line_length = calc_longest_line_length(text)
  end

  private

  def calc_longest_line_length(text)
    return nil if text.nil?
    lines = text.lines.map(&:chomp)
    lines.collect{ |l| l.length }.max
  end

  def calc_text_rows(text)
    return nil if text.nil?
    text.lines.map(&:chomp).count
  end
end
