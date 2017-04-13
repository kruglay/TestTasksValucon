require 'rails_helper'

RSpec.describe "contacts/new", type: :view do
  it 'render email, text, button, error messages' do
    @contact = Contact.new(email: "123", text: "message")
    @contact.valid?
    render

    expect(rendered).to match 'email'
    expect(rendered).to match 'text'
    expect(rendered).to match 'Send'
    expect(rendered).to match 'alert alert-danger'
  end

  it 'not render errors' do
    @contact = Contact.new(email: "123@n.ry", text: "message")
    @contact.valid?
    render

    expect(rendered).to_not match 'alert alert-danger'
  end
end
