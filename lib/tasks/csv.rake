require 'csv'

namespace :csv do
  desc "TODO"
  task import: :environment do
    create_classrooms
    parse_family_CSV_info("#{Rails.root}/lib/csv/family_info.csv")
    parse_student_CSV_info("#{Rails.root}/lib/csv/student_info.csv")
  end

  private

    def parse_family_CSV_info(family_info_filepath)
      CSV.foreach(family_info_filepath, headers: true) do |row|
        family = Family.where(name: row[0]).first_or_create
        student_names = Student.parse_student_names(family.name)
        create_students(student_names, family)

        member = family.members.where(member_params(row)).first_or_create
        User.create_unregistered_user(member, true)
      end
    end

    def parse_student_CSV_info(student_info_filepath)
      file = "#{Rails.root}/lib/csv/info_not_recorded.txt"
      File.open(file, 'w') do |file|
        CSV.foreach(student_info_filepath, headers: true) do |row|
          classroom = Classroom.where(name: classroom_name(row[3])).first
          grade = row[2]
          name_array = row[1].split(" ")

          student = Student.where(first_name: name_array.first, last_name: name_array.last).first
          update_student_info(student, classroom, grade, row[1], name_array, file)
        end
      end
    end

    def update_student_info(student, classroom, grade, name, name_array, file)

      if student
        student.update(classroom: classroom, grade: grade, archived: false)
      else
        file.puts name
      end
    end

    def member_params(row)
      { first_name: row[2],
        last_name: row[3],
        relationship_to_student: row[15],
        street_address: row[5],
        city: row[7],
        state: row[8],
        zip: row[9],
        phone: row[10],
        email: row[13],
        archived: false }
    end

    def create_students(student_names, family)
      student_names.each do |name|
        name_array = name.split(" ")
        family.students.where(first_name: name_array.first, last_name: name_array.last).first_or_create
      end
    end

    def create_classrooms
      Classroom.CLASSROOMS.each do |name, level|
        Classroom.where(name: name, level: level).first_or_create
      end
    end

    def classroom_name(classroom)
      if classroom.include?("SFA")
        "SFA"
      else
        classroom.slice(classroom.rindex("-")+1, classroom.length)
      end
    end
end
