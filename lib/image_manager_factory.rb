class ImageManagerFactory
  def self.create
    return ImageManager if Rails.env == "production"
    return ImageManagerDev
  end
end
