class Borough < ActiveRecord::Base
  has_many :reports

  def slug
    (name.downcase.gsub(" ","_"))
  end

end
