require 'rails_helper'
# Dragonfly.app.use_datastore(:memory)

RSpec.describe PhotosController, type: :controller do
  context "GET #index" do
    it "returns http success" do
      get :index

      photos    = assigns(:photos)
      new_photo = assigns(:new_photo)

      expect(photos).to eq Photo.all
      expect(new_photo).to be_a(Photo)
      expect(response).to have_http_status(:success)
    end
  end

  context "POST #create" do
    it "create photo, and returns http success" do
      expect {
        post :create, photo: {
            image: ActionDispatch::Http::UploadedFile.new(
                type:     'image/jpeg',
                head:     'headers',
                filename: 'Mountains.jpg',
                tempfile: Tempfile.open('temp')
            )
        }
      }.to change(Photo, :count).by(1)
      expect(response).to have_http_status(:redirect)
      expect(flash[:notice]).to eq 'Photo added'
    end
  end
end
