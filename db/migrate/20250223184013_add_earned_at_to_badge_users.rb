class AddEarnedAtToBadgeUsers < ActiveRecord::Migration[7.2]
  class BadgeUser < ActiveRecord::Base; end

  def up
    add_column :badge_users, :earned_at, :datetime
    BadgeUser.reset_column_information

    BadgeUser.all.each do |badge_user|
      badge_user.update_attribute!(:earned_at, badge_user.created_at) if badge_user.earned?
    end
  end

  def down
    remove_column :badge_users, :earned_at
  end
end
