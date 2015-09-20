class ActivitiesController < ApplicationController
  before_action :require_admin

  def index
    @categories = Category.active
    @activities = Activity.active
    @activity = Activity.new
  end

  def create
    category = Category.find(activity_params.fetch(:category_id))
    activity = category.activities.new(activity_params)
    if activity.save
      flash[:notice] = activity.name + " added to "+ category.name + " successfully."
    else
      flash[:alert] = "The activity, " + activity.name + ", did not save. Each activity must have a unique name.  Please try again."
    end
    redirect_to :back
  end

  def show
    @activity = Activity.find params[:id]
    @subactivities = @activity.subactivities.active
    @subactivity = Subactivity.new
  end

  def archive
    @activity = Activity.find(params[:id])
    @activity.archive_activity
    flash[:notice] = "Activity successfully deleted"
    redirect_to category_path @activity.category
  end

  def edit
    @activity = Activity.find(params[:id])
  end

  def update
    @activity = Activity.find(params[:id])
    if @activity.update(activity_params)
      flash[:notice] = "Activity successfully updated"
      redirect_to @activity.category
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  private

  def activity_params
    params.require(:activity).permit(:name, :category_id, :assigned_hours)
  end
end
