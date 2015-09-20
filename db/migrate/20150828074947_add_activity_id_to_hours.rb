class AddActivityIdToHours < ActiveRecord::Migration
  def change
    add_column :hours, :activity_id, :integer
  end
end
