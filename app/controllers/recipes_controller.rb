class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def index
    @recipes = Recipe.all
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    3.times do
      @recipe.ingredients.build
    end
    3.times do
      @recipe.instructions.build
    end
  end

  def create
    recipe = Recipe.new(recipe_params)
    flash[:success] = "Recipe created!"
    if recipe.save
      redirect_to recipe_path(recipe)
    else
      render :new
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update_attributes(recipe_params)
      flash[:success] = "Recipe updated!"
      redirect_to recipe_path(@recipe)
    else
      render :edit
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, instructions_attributes: [:content], ingredients_attributes: [:name], category_ids: [], categories_attributes: [:name])
  end
end
