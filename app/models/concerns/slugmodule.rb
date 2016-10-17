module SlugModule
  module InstanceMethods

    def slug
      name.downcase.gsub(" ","-")
    end

  end

  module ClassMethods

    def find_by_slug(slug)
      self.all.find{|x| x.slug == slug}
    end

  end
end
