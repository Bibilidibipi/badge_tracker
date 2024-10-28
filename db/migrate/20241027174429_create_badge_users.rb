class CreateBadgeUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :badge_users do |t|
      t.integer :badge_id, null: false
      t.integer :user_id, null: false
      t.boolean :earned
      t.boolean :eligible

      t.timestamps
    end

    add_index :badge_users, [ :user_id, :badge_id ], unique: true
  end
end
