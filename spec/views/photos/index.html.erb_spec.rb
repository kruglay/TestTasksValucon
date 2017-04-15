require 'rails_helper'

RSpec.describe "photos/index.html.erb", type: :view do
  it 'render Save button, Image' do
    Photo.create(image_uid: '123', image_name: '123.img')
    @new_photo = Photo.new
    @photos = Photo.all

    render

    expect(rendered).to match 'Save'
    expect(rendered).to match 'Image'
    expect(rendered).to match '123.img'
  end
end
