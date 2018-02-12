class User < ActiveRecord::Base
    has_many :messages
    has_many :owners
    has_many :posts
    has_many :blogs, through: :owners

    EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
    validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
end
