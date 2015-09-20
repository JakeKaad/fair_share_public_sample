class RenameSubmittedByWithId < ActiveRecord::Migration
  def change
    rename_column :hours, :submitted_by, :submitted_by_id
  end
end
