class RenameCreatorIdOnHours < ActiveRecord::Migration
  def change
    rename_column :hours, :submitted_by, :creator_id
  end
end
