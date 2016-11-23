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

  private

  def review_params
    params.require(:review).permit(:content, :recipe_id)
  end
end
