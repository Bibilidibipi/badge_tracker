class CreateBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :badges do |t|
      t.string :name, null: false

      t.timestamps null: false
    end
  end
end
