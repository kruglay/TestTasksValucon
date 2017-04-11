class ContactsController < ApplicationController

  def index
  end

  def show
    redirect_to new_contacts_path
  end

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      redirect_to new_contacts_path, notice: 'Message sent'
    else
      render :new
    end
  end

  private

    def contact_params
      params.require(:contact).permit(:email, :text)
    end
end
