class PhotosController < ApplicationController
  def index
    @photos = Photo.all
    @new_photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    if @photo.save
      redirect_to photos_path, notice: 'Photo added'
    else
      redirect_to photos_path, alert: 'Something went wrong'
    end
  end

  private
    def photo_params
      params.require(:photo).permit(:image)
    end
end
