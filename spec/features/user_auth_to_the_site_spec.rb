require 'rails_helper'

feature 'User login to the site' do
  scenario 'successfully' do
    user = User.create!(email: 'user@amail.com', password: '123456')

    visit root_path
    click_on 'Entrar'

    within('form') do
      fill_in 'Email', with: user.email
      fill_in 'Senha', with: user.password
      click_on 'Entrar'
    end

    expect(current_path).to eq root_path
    expect(page).not_to have_link 'Entrar'
    expect(page).to have_link 'Sair'
  end
end
