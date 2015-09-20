class DropAssignedHoursFromActivities < ActiveRecord::Migration
  def change
    remove_column :activities, :assigned_hours
  end
end
