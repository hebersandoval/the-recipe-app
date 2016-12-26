class ReviewsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def create
    @recipe = Recipe.find(params[:recipe_id])
    @review = @recipe.reviews.build(review_params)
    # byebug
    # @review = Review.new(review_params)
    if @review.save
      flash[:success] = "Review created!"
      redirect_to user_recipe_path(@review.user, @review.recipe)
      # redirect_to recipe_review_path(review.recipe, review)
      # redirect_to user_recipe_path(@recipe.user, @recipe)
    end
  end

  def destroy
    @recipe = Recipe.find(params[:recipe_id])
    @review = @recipe.reviews.find(params[:id])
    @review.destroy
    flash[:danger] = "Review deleted!"
    redirect_to user_recipe_path(@review.user, @review.recipe)
  end
  
  private

  def review_params
    params.require(:review).permit(:content, :user_id)
  end
end
