class EnforceUniquenessOnBadgesName < ActiveRecord::Migration[7.2]
  def change
    add_index :badges, :name, unique: true
  end
end
