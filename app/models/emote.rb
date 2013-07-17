class Emote < ActiveRecord::Base
  attr_accessor :api_meta
  after_initialize do |emote|
    emote.api_meta = Hashie::Mash.new
  end

  validates :text, presence: true, uniqueness: true

  # Make sure the text numerics are assigned properly and display row/columns are calculated once
  before_create :calculate_display_columns
  before_create :calculate_display_rows
  before_save   :assign_text_numeric_vals

  scope :all_tags, -> (tags) { where("tags ?& ARRAY[:tags]", tags: tags) }
  scope :any_tags, -> (tags) { where("tags ?| ARRAY[:tags]", tags: tags) }

  default_scope { order('created_at DESC') }

  # When creating tags, this should always be used, not save
  def create_with(user)
    user = User.find(user) if user.kind_of? String
    raise ActiveRecord::RecordNotFound unless user.kind_of? User

    ActiveRecord::Base.transaction do
      save
      UserEmote.create kind: "Owner", user_id: user.id, emote_id: self.id
      UserEmote.tag user, self, self.tags.keys
    end
  end

  def favorited_by(user)
    user = User.find(user) if user.kind_of? String
    raise ActiveRecord::RecordNotFound unless user.kind_of? User

    UserEmote.create kind: "Favorited", user_id: user.id, emote_id: self.id
  end

  # TAGGING
  def tags=(input)
    # Convenience for creating emotes for the first time
    if input.kind_of? Array
      raise TagArrayNotAllowedError if self.id
      input = Hash[input.map {|t| [t,1]}]
    end

    input.keys.each do |key|
      input[(key.to_sym rescue key) || key] = input.delete(key)
    end
    super
  end

  def add_tags(user, tags)
    # TODO: This errors out when you try to send it a tag that already exists:
    # TypeError (no implicit conversion of Fixnum into String):
    #      app/models/emote.rb:71:in `+'
    # app/models/emote.rb:71:in `block in add_tags'
    # app/models/emote.rb:67:in `each'

    user = User.find(user) if user.kind_of? String
    raise ActiveRecord::RecordNotFound unless user.kind_of? User

    UserEmote.tag user, self, tags

    tags.each do |tag|
      tag = tag.to_s
      if self.tags.has_key? tag
        self.tags[tag] += 1
      else
        self.tags[tag] = 1
      end
    end

    # This is needed due to an issue with Rails4 to not be able to detect changes on hstore changes, and thus save will
    # not fire off unless you explicitly tell it one of the fields has changed.
    tags_will_change!
    save
  end

  def assign_text_numeric_vals
    self.text_rows  = calc_text_rows(text)
    self.max_length = calc_max_length(text)
  end

  # CUSTOM RELATIONSHIPS (all indexed)
  def owner
    result = UserEmote.includes(:user).where(kind: 'Owner', emote_id: self.id).limit(1)
    result.first.user unless result.empty?
  end

  def tagged
    UserEmote.includes(:user).where(kind: 'Tagged', emote_id: self.id).map do |result|
      result.user
    end
  end

  def favorited
    UserEmote.includes(:user).where(kind: 'Favorited', emote_id: self.id).map do |result|
      result.user
    end
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
    assign_text_numeric_vals
    # TODO: Add this to the migration as the default for display_columns
    if self.display_columns.nil?
      self.display_columns = 1
    end
  end

  def calculate_display_rows
    # TODO: Add this to the migration as the default for display_columns
    if self.display_rows.nil?
      self.display_rows = 1
    end
  end
end

class TagArrayNotAllowedError < StandardError
end