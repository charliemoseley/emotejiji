class UserEmote < ActiveRecord::Base
  validates :kind, inclusion: { in: %w(owner favorited tagged) }

  belongs_to :user
  belongs_to :emote
end
