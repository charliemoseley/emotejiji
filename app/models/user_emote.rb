class UserEmote < ActiveRecord::Base
  validates :kind, inclusion: { in: %w(Owner Favorited Tagged) }

  belongs_to :user
  belongs_to :emote
end
