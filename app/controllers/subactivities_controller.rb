class SubactivitiesController < ApplicationController
  before_action :require_admin

  def index
    @activities = Activity.all
    @subactivity = Subactivity.new
  end

  def create
    activity = Activity.find(subactivity_params.fetch(:activity_id))
    subactivity = activity.subactivities.new(subactivity_params)
    if subactivity.save
      flash[:notice] = subactivity.name + " added to "+ activity.name + " successfully."
    else
      flash[:alert] = "The subactivity, " + subactivity.name + ", did not save. Please try again."
    end
    redirect_to :back
  end

  def edit
    @subactivity = Subactivity.find(params[:id])
  end

  def update
    @subactivity = Subactivity.find(params[:id])
    if @subactivity.update(subactivity_params)
      flash[:notice] = "Subactivity successfully updated"
      redirect_to @subactivity.activity
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  def archive
    subactivity = Subactivity.find(params[:id])
    subactivity.toggle_archived
    flash[:notice] = "Subactivity successfully deleted"
    redirect_to subactivity.activity
  end

  private

  def subactivity_params
    params.require(:subactivity).permit(:name, :activity_id, :assigned_hours)
  end
end
