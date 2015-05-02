require 'rails_helper'

RSpec.feature "UsersIndex", type: :feature do
  given(:admin) { users(:michael) }
  given!(:non_admin) { users(:archer) }

  scenario "index as admin including pagination and delete links" do
    log_in_as(admin)
    visit users_path
    expect(page).to have_selector 'h1', text: 'All users'
    expect(page).to have_selector 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      expect(page).to have_link user.name, href: user_path(user)
      unless user == admin
        expect(page).to have_delete_link 'delete', href: user_path(user)
      end
    end
    expect { click_link 'delete', href: user_path(non_admin) }.to change { User.count }.by(-1)
  end

  scenario "index as non-admin" do
    log_in_as(non_admin)
    visit users_path
    expect(page).to have_no_link 'delete'
  end
end
