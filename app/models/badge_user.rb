class BadgeUser < ApplicationRecord
    belongs_to :user
    belongs_to :badge
    validates :user, presence: true
    validates :badge, presence: true, uniqueness: { scope: :user }
    validates :earned, :eligible, inclusion: [ true, false ]
    validates :earned, inclusion: { in: [ false ], message: "can't be true if eligible is false" }, unless: :eligible?
    validates :earned_at, presence: true, if: :earned?
    after_initialize :set_defaults
    before_validation :set_earned_at

    private

    def set_defaults
        self.earned ||= false
        self.eligible ||= false
    end

    def set_earned_at
        if will_save_change_to_earned? && earned?
            self.earned_at = Time.now # updated_at_change_to_be_saved[1] doesn't work; could put it in an after_save callback
        end
    end
end
