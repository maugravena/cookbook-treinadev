class RecipeTypesController < ApplicationController
  def new
    @recipe_type = RecipeType.new
  end

  def create
    @recipe_type = RecipeType.create(params.require(:recipe_type).permit(:name))

    if @recipe_type.valid?
      redirect_to @recipe_type
    else
      flash[:error] = 'Você deve informar o nome do tipo de receita'
      redirect_to :new_recipe_type
    end
  end

  def show
    @recipe_type = RecipeType.find(params[:id])
  end
end
