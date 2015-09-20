class UpdateSchoolYearsJoinTable < ActiveRecord::Migration
  def change
    rename_table :school_year_students, :school_years_students
  end
end
