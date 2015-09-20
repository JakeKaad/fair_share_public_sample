class DropActivityIdFromHours < ActiveRecord::Migration
  def change
    remove_column :hours, :activity_id
  end
end
