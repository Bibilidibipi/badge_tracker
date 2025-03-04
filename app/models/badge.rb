class Badge < ApplicationRecord
    has_many :badge_users, dependent: :destroy
    has_many :users, through: :badge_users
    has_one_attached :image
    validates :name, presence: true, uniqueness: true

    def image
        super.persisted? ? super : "badge.png"
    end
end
