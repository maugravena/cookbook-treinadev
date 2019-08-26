require 'rails_helper'

feature 'no authenticated user cant create recipe' do
  scenario 'successfully' do
    visit root_path

    expect(page).not_to have_link 'Enviar uma receita'
  end

  scenario 'no authenticated user cant access create recipe url' do
    visit root_path
    visit new_recipe_path

    expect(current_path).to eq user_session_path
  end
end
