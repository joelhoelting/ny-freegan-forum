class Report < ActiveRecord::Base
  belongs_to :user
  belongs_to :borough


  def slug
    (title.downcase.gsub(" ","-"))+"-"+(self.user_id.to_s)
  end

  extend SlugModule::ClassMethods

end
