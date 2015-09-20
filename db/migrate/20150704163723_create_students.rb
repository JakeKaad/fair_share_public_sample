class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.belongs_to :classroom
      t.string :grade
      t.boolean :enrolled
      t.belongs_to :family
      t.timestamps
    end
  end
end
