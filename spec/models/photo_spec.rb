require 'rails_helper'

RSpec.describe Photo, type: :model do
  context 'validation check' do
    it { should validate_presence_of :image_name }
  end
end
