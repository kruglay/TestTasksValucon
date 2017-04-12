require 'rails_helper'

RSpec.feature 'create contact', type: :feature do
  scenario 'success' do
    @contact = Contact.new
    visit '/'

    click_link 'Feed back'

    expect(page).to have_field('contact[email]')
    expect(page).to have_field('contact[text]')
    expect(page).to have_button('Send')

    fill_in 'contact_email', with: '123@mail.ru'
    fill_in 'contact_text', with: 'test message'

    click_button 'Send'

    expect(page.current_path).to eq new_contacts_path
    expect(page).to have_content 'Message sent'
    expect(find_field('contact_email').text).to eq ''
    expect(find_field('contact_text').text).to eq ''

    save_and_open_page
  end
end
