require 'rails_helper'

RSpec.feature "MicropostsInterface", type: :feature do
  given(:user) { users(:michael) }

  scenario "micropost interface" do
    log_in_as(user)
    visit root_path
    expect(page).to have_selector 'div.pagination'
    # Invalid submission
    fill_in 'micropost_content', with: ""
    expect { click_button 'Post' }.to_not change { Micropost.count }
    expect(page).to have_selector 'div#error_explanation'
    # Valid submission
    content = "This micropost really ties the room tovisither"
    fill_in 'micropost_content', with: content
    expect { click_button 'Post' }.to change { Micropost.count }.by(1)
    expect(current_url).to eq root_url
    expect(page).to have_content content
    # Delete a post.
    expect(page).to have_link 'delete'
    first_micropost = user.microposts.paginate(page: 1).first
    expect { click_link 'delete', href: micropost_path(first_micropost) }.to change { Micropost.count }.by(-1)
    # Visit a different user.
    archer = users(:archer)
    visit user_path(archer)
    expect(archer.microposts).to be_present
    expect(page).to have_no_link 'delete'
  end
end
