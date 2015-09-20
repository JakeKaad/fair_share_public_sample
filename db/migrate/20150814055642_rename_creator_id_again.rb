class RenameCreatorIdAgain < ActiveRecord::Migration
  def change
    rename_column :hours, :creator_id, :submitted_by
  end
end
