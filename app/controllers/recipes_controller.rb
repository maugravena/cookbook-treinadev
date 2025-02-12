class RecipesController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update]

  def index
    @recipes = if params[:q]
      Recipe.where('title LIKE ?', "#{params[:q]}%")
    else
      Recipe.all
    end

    if @recipes.empty?
      flash[:error] = 'Não foi possível encontrar a receita'
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def new
    @recipe = Recipe.new
    @recipe_types = RecipeType.all
    @cuisines = Cuisine.all
  end

  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.user = current_user

    if @recipe.save
      redirect_to @recipe
    else
      @recipe_types = RecipeType.all
      @cuisines = Cuisine.all
      flash[:error] = 'Não foi possível salvar a receita'
      redirect_to :new_recipe
    end
  end

  def edit
    @recipe = Recipe.find_by(params[:id])
    @recipe_types = RecipeType.all
    @cuisines = Cuisine.all
  end

  def update
    @recipe = Recipe.find_by(params[:id])
    @recipe.update(recipe_params)

    if @recipe.valid?
      redirect_to @recipe
    else
      flash[:error] = 'Não foi possível salvar a receita'
      redirect_to :edit_recipe
    end
  end

  def user_recipes
    @recipes = Recipe.where(user: current_user)
  end

  private

  def recipe_params
    params
      .require(:recipe)
      .permit(:title,
              :recipe_type_id,
              :cuisine_id,
              :difficulty,
              :cook_time,
              :ingredients,
              :cook_method,
              :recipe_photo,
              :q)
  end
end
