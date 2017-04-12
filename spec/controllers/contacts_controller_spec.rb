require 'rails_helper'

RSpec.describe ContactsController, type: :controller do
  describe "GET #contacts" do
    it "redirect to /contacts/new" do
      get :show
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to new_contacts_path
    end
  end

  describe "POST #contacts" do

    it "create contact" do
      post :create, contact: { email:"123@r.com", text:"message" }

      contact = assigns(:contact)

      expect(contact.email).to eq '123@r.com'
      expect(contact.text).to eq 'message'
      expect(response).to redirect_to new_contacts_path
      expect(flash[:notice]).to eq 'Message sent'
    end

    it 'not create contact, render new' do
      post :create, contact: { email:"123", text:"message" }

      contact = assigns(:contact)

      expect(contact.errors).to be
      expect(response).to render_template :new
    end
  end
end
