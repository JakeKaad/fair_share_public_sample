class MembersController < ApplicationController
  before_action :require_admin, only: [:create, :index, :archive, :search, :invite]
  before_action :require_login, only: [:show]
  before_action :require_admin_or_owner, only: [:edit, :update]
  before_action :require_owner, only: [:add_activity, :remove_activity]

  def index
    @members = organize_by_tabs(params[:tab])
  end

  def show
    @member = Member.find(params[:id])
    @family = @member.family
    @categories = Category.all.order(:name)
    @activities = Activity.all.order(:category_id, :name)
  end

  def create
    family = Family.find(params[:family_id])
    member = family.members.new(member_params)
    if member.save
      if member.email.present?
       User.create_unregistered_user(member)
      end
      flash[:notice] = "Yay! Family member successfully added."
    else
      flash[:alert] = "Uh oh...give it another go.  The family member was not saved."
    end
    redirect_to :back
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      if @member.user
        @member.user.update(email: @member.email)
      end
      flash[:notice] = "Profile successfully updated"
      redirect_to @member
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  def add_activity
    member = Member.find(params[:member_id])
    owner_only(member)
    activity = Activity.find(params[:activity_id])
    member.activities.push(activity)
    respond_to do |f|
      f.html { redirect_to member }
      f.js {}
    end
  end

   def remove_activity
    member = Member.find(params[:member_id])
    owner_only(member)
    member.activities.delete(Activity.find params[:activity_id])
    respond_to do |f|
      f.html { redirect_to member }
      f.js {}
    end
  end

  def add_all_activities
    member = Member.find(params[:id])
    owner_only(member)
    @category = Category.find(params[:category_id])
    @category.activities.each { |activity| member.activities.push(activity) }
    respond_to do |f|
      f.html { redirect_to member }
      f.js {}
    end
  end

  def remove_all_activities
    member = Member.find(params[:id])
    owner_only(member)
    @category = Category.find(params[:category_id])
    @category.activities.each { |activity| member.activities.delete(activity) }
    respond_to do |f|
      f.html { redirect_to member }
      f.js {}
    end
  end

  def archive
    Member.find(params[:id]).toggle_archived
    @members = organize_by_tabs(params[:tab])
    respond_to do |f|
      f.html { redirect_to :back }
      f.js {}
    end
  end

  def search
    query = params[:query]
    if params[:tab].nil?
      @members = Member.active.where("LOWER(first_name) LIKE LOWER('%#{query}%') OR LOWER(last_name) LIKE LOWER('%#{query}%')")
    elsif params[:tab] == "archived"
      @members = Member.archived.where("LOWER(first_name) LIKE LOWER('%#{query}%') OR LOWER(last_name) LIKE LOWER('%#{query}%')")
    elsif params[:tab] == "all"
      @members = Member.where("LOWER(first_name) LIKE LOWER('%#{query}%') OR LOWER(last_name) LIKE LOWER('%#{query}%')")
    end
    respond_to do |f|
      f.js {  }
    end
  end

  def invite
    @member = Member.find(params[:id])
    FairShareMailer.delay.send_welcome_email(@member.user.id)
    respond_to do |f|
      f.html { redirect_to :back }
      f.js {}
    end
  end

  private

  def member_params
    params.require(:member).permit(:first_name, :last_name, :relationship_to_student, :phone, :email, :state, :street_address, :city, :zip)
  end

  def member_email
    params[:member][:email]
  end

  def organize_by_tabs(tab)
    if tab.nil?
      Member.active
    elsif tab == "archived"
      Member.archived
    elsif tab == "all"
      Member.all
    end
  end

  def owner_only(member)
    user_id = member.user.id if current_user
    redirect_to root_path unless current_user && user_id == current_user.id
  end
end
