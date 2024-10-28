class BadgeUser < ApplicationRecord
    belongs_to :user
    belongs_to :badge
    validates :user, presence: true
    validates :badge, presence: true, uniqueness: { scope: :user }
    validates :earned, :eligible, inclusion: [ true, false ]
    after_initialize :set_defaults

    private

    def set_defaults
        self.earned ||= false
        self.eligible ||= false
    end
end
