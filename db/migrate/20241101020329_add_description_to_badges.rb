class AddDescriptionToBadges < ActiveRecord::Migration[7.2]
  def change
    add_column :badges, :description, :text
  end
end
