class AddColumnsSchoolYearsStudents < ActiveRecord::Migration
  def change
    add_column :school_years_students, :student_id, :integer
    add_column :school_years_students, :school_year_id, :integer
  end
end
