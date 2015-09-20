class CreateSubactivities < ActiveRecord::Migration
  def change
    create_table :subactivities do |t|
      t.string :name
      t.integer :activity_id
      t.integer :assigned_hours

      t.timestamps
    end
  end
end
