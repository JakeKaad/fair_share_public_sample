class StudentsController < ApplicationController
  before_action :require_admin

  def index
    @students = organize_by_tabs(params[:tab])
  end

  def create
    family = Family.find(params[:family_id])
    student = family.students.new(student_params)
    student.enrolled = true
    if student.save
      flash[:notice] = "Student saved successfully"
    else
      flash[:alert] = "Student not saved."
    end
    redirect_to :back
  end

  def edit
    @student = Student.find(params[:id])
  end

  def update
    @student = Student.find(params[:id])
    if @student.update(student_params)
      flash[:notice] = "Student profile updated"
      redirect_to students_path
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  def archive
    Student.find(params[:id]).toggle_archived
    @students = organize_by_tabs(params[:tab])
    respond_to do |f|
      f.html { redirect_to :back }
      f.js {}
    end
  end

  def search
    query = params[:query]
    if params[:tab].nil?
      @students = Student.active.where("LOWER(first_name) LIKE LOWER('%#{query}%') OR LOWER(last_name) LIKE LOWER('%#{query}%')")
    elsif params[:tab] == "archived"
      @students = Student.archived.where("LOWER(first_name) LIKE LOWER('%#{query}%') OR LOWER(last_name) LIKE LOWER('%#{query}%')")
    elsif params[:tab] == "all"
      @students = Student.where("LOWER(first_name) LIKE LOWER('%#{query}%') OR LOWER(last_name) LIKE LOWER('%#{query}%')")
    end
    respond_to do |f|
      f.js {  }
    end
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :classroom_id, :grade)
  end

  def organize_by_tabs(tab)
    if tab.nil?
      Student.active
    elsif tab == "archived"
      Student.archived
    elsif tab == "all"
      Student.all
    end
  end
end
