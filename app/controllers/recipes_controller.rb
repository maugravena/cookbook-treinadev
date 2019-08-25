class RecipesController < ApplicationController
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
    @recipe = Recipe.create(recipe_params)

    if @recipe.valid?
      redirect_to @recipe
    else
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

  #def search
  #  @recipes = Recipe.where(title: params[:q])
  #end

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
              :q)
  end
end
