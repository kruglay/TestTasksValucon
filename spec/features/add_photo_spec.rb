require 'rails_helper'
# Dragonfly.app.use_datastore(:memory)

RSpec.feature 'add photo', type: :feature do
  scenario 'success' do
    @new_photo = Photo.new

    visit photos_path

    attach_file('Image', __dir__ + '/fixtures/Mountains.jpg')
    expect {
      click_button 'Save'
    }.to change { all('img').count }.by(1)
    expect(page).to have_content('Photo added')
  end
end
