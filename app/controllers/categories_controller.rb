class CategoriesController < ApplicationController
  before_action :require_admin

  def index
    @categories = Category.active
    @activities = Activity.active
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: "Category successfully created."
    else
      flash[:alert] = "A category must have a unique name."
      redirect_to :back
    end
  end

  def show
    @category = Category.find params[:id]
    @activities = @category.activities.active
    @activity = Activity.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      flash[:notice] = "Category successfully updated"
      redirect_to @category
    else
      flash[:alert] = "Something went wrong"
      render :edit
    end
  end

  def archive
    @category = Category.find(params[:id])
    @category.archive_category
    flash[:notice] = "Category successfully deleted"
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
