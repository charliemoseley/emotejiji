class UserEmote < ActiveRecord::Base
  validates :kind, inclusion: { in: %w(owner favorite tagged) }
end
