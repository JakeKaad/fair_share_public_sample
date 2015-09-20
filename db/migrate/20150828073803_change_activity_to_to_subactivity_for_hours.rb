class ChangeActivityToToSubactivityForHours < ActiveRecord::Migration
  def change
    rename_column :hours, :activity_id, :subactivity_id
  end
end
