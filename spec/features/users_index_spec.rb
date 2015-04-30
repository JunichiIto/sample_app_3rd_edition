require 'rails_helper'

RSpec.feature "UsersIndex", type: :feature do
  let(:admin) { create :michael }
  let!(:non_admin) { create :archer }
  
  before do 
    create_list :user, 30
  end
  
  specify "index as admin including pagination and delete links" do
    log_in_as(admin)
    visit users_path
    expect(page).to have_selector 'h1', text: 'All users'
    expect(page).to have_selector 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      expect(page).to have_link user.name, href: user_path(user)
      unless user == admin
        # TODO Check data-method attribute
        expect(page).to have_link 'delete', user_path(user)
      end
    end
    expect { click_link 'delete', href: user_path(non_admin) }.to change { User.count }.by(-1)
  end

  specify "index as non-admin" do
    log_in_as(non_admin)
    visit users_path
    expect(page).to have_no_link 'delete'
  end
end
