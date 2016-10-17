class User < ActiveRecord::Base
  has_secure_password
  has_many :reports

  def slug
    username.downcase.gsub(" ","-")
  end

  extend SlugModule::ClassMethods

end
