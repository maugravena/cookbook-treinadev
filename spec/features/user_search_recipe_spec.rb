require 'rails_helper'

feature 'User search recipe' do
  scenario 'successfully' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    RecipeType.create(name: 'Entrada')
    cuisine = Cuisine.create(name: 'Brasileira')
    Cuisine.create(name: 'Arabe')
    user = User.create(email: 'user@email.com', password: '123456')
    Recipe.create(user: user, title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    visit root_path
    fill_in 'Pesquisar receita', with: 'Bolo de cenoura'
    click_on 'Pesquisar'

    expect(page).to have_css('h1', text: 'Bolo de cenoura')
  end

  scenario 'search by exact name and not find' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    RecipeType.create(name: 'Entrada')
    cuisine = Cuisine.create(name: 'Brasileira')
    Cuisine.create(name: 'Arabe')
    user = User.create(email: 'user@email.com', password: '123456')
    Recipe.create(user: user, title: 'Torta de maça', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    visit root_path
    fill_in 'Pesquisar receita', with: 'Bolo de cenoura'
    click_on 'Pesquisar'

    expect(page).to have_content 'Não foi possível encontrar a receita'
  end

  scenario 'search for a recipe by partial name and find more than one' do
    recipe_type = RecipeType.create(name: 'Sobremesa')
    RecipeType.create(name: 'Entrada')
    cuisine = Cuisine.create(name: 'Brasileira')
    Cuisine.create(name: 'Arabe')
    user = User.create(email: 'user@email.com', password: '123456')
    recipe = Recipe.create(user: user, title: 'Torta de maça', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    recipe_type = RecipeType.create(name: 'Sobremesa')
    RecipeType.create(name: 'Entrada')
    cuisine = Cuisine.create(name: 'Brasileira')
    Cuisine.create(name: 'Arabe')
    other_user = User.create(email: 'other_user@email.com', password: '123456')
    other_recipe = Recipe.create(user: other_user, title: 'Torta de morango', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    visit root_path
    fill_in 'Pesquisar receita', with: 'tor'

    expect(page).to have_css('h1', text: recipe.title)
    expect(page).to have_css('h1', text: other_recipe.title)
  end
end
