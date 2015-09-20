class AddClassroomLevel < ActiveRecord::Migration
  def change
    add_column :classrooms, :level, :string
  end
end
