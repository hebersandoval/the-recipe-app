class ReviewsController < ApplicationController
  # before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  #
  # def index
  #   # params provided by Rails through the nested route, by taking the parent
  #   # resource's name and appending '_id' to it
  #   # if params[:recipe_id]
  #     # @reviews = Recipe.find(params[:recipe_id]).reviews
  #   # else
  #     @reviews = Review.all
  #   # end
  # end
  #
  # def show
  #   @review = Review.find(params[:id])
  # end
  #
  # def new
  #   # if params[:recipe_id] && !Recipe.exists?(params[:recipe_id])
  #     # redirect_to recipes_path, alert: "Recipe not found!"
  #   # else
  #     # @review = Review.new(recipe_id: params[:recipe_id])
  #   # end
  #   @review = @recipe.reviews.build
  # end
  #
  def create
    # raise params.inspect
    @recipe = Recipe.find(params[:recipe_id])
    @review = @recipe.reviews.build(review_params)
    # byebug
    # @review = Review.new(review_params)
    # @review = @recipe.reviews.build(review_params)
    @review.save
    # redirect_to recipe_path(@review.recipe)
    # redirect_to recipe_review_path(review.recipe, review)
    redirect_to user_recipe_path(@recipe.user, @recipe)
  end
  #
  # def edit
  #   # if params[:recipe_id]
  #     # recipe = Recipe.find_by(id: params[:recipe_id])
  #     # if recipe.nil?
  #       # redirect_to recipes_path, alert: "Recipe not found!"
  #     # else
  #       # @review = recipe.reviews.find_by(id: params[:id])
  #       # redirect_to recipe_reviews_path(recipe), alert: "Review not found!" if @review.nil?
  #     # end
  #   # else
  #     @review = Review.find(params[:id])
  #   # end
  # end
  #
  # def update
  #   @review = Review.find(params[:id])
  #   @review.update(review_params)
  #   redirect_to review_path(@review)
  # end
  #
  private

  def review_params
    params.require(:review).permit(:content, :user_id)
  end
end
