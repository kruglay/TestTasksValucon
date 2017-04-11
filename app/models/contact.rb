class Contact < ActiveRecord::Base
  validates :email, presence: true, format: {
      :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/
  }
  validates :text, presence: true
end
