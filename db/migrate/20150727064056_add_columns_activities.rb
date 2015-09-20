class AddColumnsActivities < ActiveRecord::Migration
  def change
    add_column :activities, :category_id, :integer
    add_column :activities, :assigned_hours, :integer
  end
end
