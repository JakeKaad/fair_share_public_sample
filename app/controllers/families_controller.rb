class FamiliesController < ApplicationController
  before_action :require_admin, only: [:index, :new, :create, :archive]
  before_action :require_login, only: [:show]

  def index
    @families = organize_by_tabs(params[:tab])
  end

  def show
    @family = Family.find params[:id]
    @students = @family.students.active
    @members = @family.members.active
    if admin_signed_in?
      @student = Student.new
      @member = Member.new
    end
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)

    if @family.save
      redirect_to @family, notice: "Family successfully created."
    else
      flash[:alert] = "A family must have a unique name."
      render :new
    end
  end

  def edit
  end

  def update
  end

  def archive
    family = Family.find(params[:id])
    family.archive_family
    @families = organize_by_tabs(params[:tab])

    respond_to do |f|
      f.html { redirect_to :back }
      f.js {}
    end
  end

  def search
    query = params[:query]
    if params[:tab].nil?
      @families = Family.active.where("LOWER(name) LIKE LOWER('%#{query}%')")
    elsif params[:tab] == "archived"
      @families = Family.archived.where("LOWER(name) LIKE LOWER('%#{query}%')")
    elsif params[:tab] == "all"
      @families = Family.where("LOWER(name) LIKE LOWER('%#{query}%')")
    end
    respond_to do |f|
      f.js {  }
    end
  end

  private

  def family_params
    params.require(:family).permit(:name)
  end

  def organize_by_tabs(tab)
    if tab.nil?
      Family.active
    elsif tab == "archived"
      Family.archived
    elsif tab == "all"
      Family.all
    end
  end
end
