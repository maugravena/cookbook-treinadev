require 'rails_helper'

feature 'Authenticated user view homepage recipes' do
  scenario 'Successfully' do
    user = User.create(email: 'user@email.com', password: '123456')
    recipe_type = RecipeType.create(name: 'Entrada')
    cuisine = Cuisine.create(name: 'Brasileira')
    Recipe.create(user: user, title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    x = User.create(email: 'user@email.com', password: '123456')
    Recipe.create(user: x, title: 'Bolo de laranja', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    visit root_path

    click_on 'Entrar'

    within('form') do
      fill_in 'Email', with: user.email
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    click_on 'Ver minhas receitas'

    expect(page).to have_css('h1', text:'Bolo de cenoura')

    expect(page).not_to have_css('h1', text:'Bolo de laranja')
  end

  scenario 'user must be sign in' do
    visit root_path

    click_on 'Ver minhas receitas'

    expect(current_path).to eq new_user_session_path
  end

  scenario 'no ownwer redirect to root path' do
    user = User.create(email: 'user@email.com', password: '123456')
    recipe_type = RecipeType.create(name: 'Entrada')
    cuisine = Cuisine.create(name: 'Brasileira')
    Recipe.create(user: user, title: 'Bolo de cenoura', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')

    x = User.create(email: 'user@email.com', password: '123456')
    recipe = Recipe.create(user: x, title: 'Bolo de laranja', difficulty: 'Médio',
                  recipe_type: recipe_type, cuisine: cuisine,
                  cook_time: 50, ingredients: 'Farinha, açucar, cenoura',
                  cook_method: 'Cozinhe a cenoura, corte em pedaços pequenos, misture com o restante dos ingredientes')
    visit root_path
    click_on 'Entrar'

    within('form') do
      fill_in 'Email', with: user.email
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    visit edit_recipe_path(recipe)

    expect(current_path).to eq root_path
  end
end
