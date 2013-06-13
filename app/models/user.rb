class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,    presence: true, format: { with: VALID_EMAIL_REGEX },
                       uniqueness: { case_sensitive: false }, allow_nil: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
  validates :password_confirmation, presence: true

  before_save :create_remember_token

  has_secure_password

  def self.find_by_username_or_email(input)
    if input.match VALID_EMAIL_REGEX
      return User.find_by_email(input)
    else
      return User.find_by_username(input)
    end
  end

  # CUSTOM RELATIONSHIPS (all indexed)
  def created_emotes
    UserEmote.includes(:emote).where(kind: 'Owner', user_id: self.id).map do |result|
      result.emote
    end
  end

  def tagged_emotes
    UserEmote.includes(:emote).where(kind: 'Tagged', user_id: self.id).map do |result|
      result.emote
    end
  end

  def favorited_emotes
    UserEmote.includes(:emote).where(kind: 'Favorited', user_id: self.id).map do |result|
      result.emote
    end
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
