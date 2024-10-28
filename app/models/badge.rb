class Badge < ApplicationRecord
    has_many :badge_users, dependent: :destroy
    has_many :users, through: :badge_users
    validates :name, presence: true
end
