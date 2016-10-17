class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :borough

  extend SlugModule::ClassMethods
  include SlugModule::InstanceMethods

end
