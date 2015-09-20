class AddArchivedToStudents < ActiveRecord::Migration
  def change
    add_column :students, :archived, :boolean
  end
end
