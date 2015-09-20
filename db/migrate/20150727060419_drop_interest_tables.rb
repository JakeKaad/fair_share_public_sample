class DropInterestTables < ActiveRecord::Migration
  def change
    drop_table :interests
    drop_table :interests_members
  end
end
