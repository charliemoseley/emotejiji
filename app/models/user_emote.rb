class UserEmote < ActiveRecord::Base
  validates :kind, inclusion: { in: %w(Owner Favorited Tagged) }

  belongs_to :user
  belongs_to :emote

  def self.tag(user, emote, tags)
    ue = UserEmote.where(kind: "Tagged", user_id: user.id, emote_id: emote.id).first_or_initialize
    ue.tags = [] if ue.tags.nil?
    ue.tags = (ue.tags + tags).uniq
    ue.save
  end
end
