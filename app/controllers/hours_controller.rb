class HoursController < ApplicationController
  before_action :require_login

  def index
    @family = Family.find(params[:family_id])
    require_family_member(@family)
    @hours = @family.hours.order(:date_earned)
    @members = @family.members.active.uniq
    @hour = Hour.new
    @activities = Activity.joins(:category).where.not("categories.name = ?", 'Incentives')
    @subactivities = Subactivity.all
  end

  def create
    member = Member.find(params["hour"]["member_id"])
    hour = member.hours.new(hour_params)
    if hour.save
      FairShareMailer.send_thank_you_for_sharing_email(current_user, hour).deliver_now if current_user
      flash[:notice] = "Thank you for contributing your time to our community."
    else
      flash[:alert] = "Oh no!  Looks like something needs to be added or corrected.  Your hours weren't recorded."
    end
    redirect_to :back
  end

  def edit
    @hour = Hour.find(params[:id])
    @family = @hour.family
    require_family_member(@family)
    @activities = Activity.active.joins(:category).where.not("categories.name = ?", 'Incentives')
    @subactivities = Subactivity.active
  end

  def update
    @hour = Hour.find(params[:id])
    family = @hour.family
    if family_member?(family)
      if @hour.update(hour_params)
        flash[:notice] = "Hour updated successfully."
        redirect_to family_hours_path(family)
      else
        flash[:alert] = "Something went wrong"
        render :edit
      end
    else
      redirect_to root_path
    end
  end

  def destroy
    @family = Family.find(params[:family_id])
    require_family_member(@family)
    if family_member?(@family)
      @hour = Hour.find(params[:id])
      @hour.destroy
      flash[:notice] = "Hours successfully deleted."
      redirect_to family_hours_path(@family)
    else
      redirect_to root_path
    end
  end

  def get_subactivities
    @activity = Activity.find params[:activity_id]
    @subactivities = @activity.subactivities
  end

  def get_quantity
    @subactivity = Subactivity.find params[:subactivity_id]
    @quantity = @subactivity.assigned_hours
  end

private
  def hour_params
    params.require(:hour).permit(:member_id, :date_earned, :quantity, :subactivity_id, :submitted_by_id)
  end

  def require_family_member(family)
    redirect_to root_path unless  family_member?(family)
  end

  def family_member?(family)
     admin_signed_in? || current_user.member.family == family
  end
end
