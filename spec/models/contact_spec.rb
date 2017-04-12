require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'validation check' do
    it { should validate_presence_of :email }
    it { should allow_value('123@com.ru').for :email }
    it { should_not allow_value('123@com').for :email }
    it { should validate_presence_of :text }
  end
end
