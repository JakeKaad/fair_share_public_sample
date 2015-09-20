class CreateSchoolYear < ActiveRecord::Migration
  def change
    create_table :school_years do |t|
      t.string :begin_year
      t.string :end_year
      t.timestamps
    end
  end
end
