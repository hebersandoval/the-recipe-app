class ReviewsController < ApplicationController
  def index
    # params provided by Rails through the nested route, by taking the parent
    # resource's name and appending '_id' to it
    if params[:recipe_id]
      @reviews = Recipe.find(params[:recipe_id]).reviews
    else
      @reviews = Review.all
    end
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new(recipe_id: params[:recipe_id])
  end

  def create
    @review = Review.new(review_params)
    @review.save
    redirect_to review_path(@review)
  end

  def edit
    if params[:recipe_id]
      recipe = Recipe.find_by(id: params[:recipe_id])
      if recipe.nil?
        redirect_to recipes_path, alert: "Recipe not found!"
      else
        @review = recipe.reviews.find_by(id: params[:id])
        redirect_to recipe_reviews_path(recipe), alert: "Review not found!" if @review.nil?
      end
    else
      @review = Review.find(params[:id])
    end
  end

  private

  def review_params
    params.require(:review).permit(:content, :recipe_id)
  end
end
