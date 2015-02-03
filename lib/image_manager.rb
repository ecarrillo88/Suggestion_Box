require "net/http"

class ImageManager
  def get_image_url(image_id)
    uri = URI.parse("http://res.cloudinary.com/suggestion-box/image/upload/#{image_id}")
    request = Net::HTTP.new uri.host
    response = request.request_head uri.path
    if response.code.to_i == 200
      return uri
    else
      return "not-available.jpg"
    end
  end

  def upload_image(image)
    Cloudinary::Uploader.upload(image)
  end

  def delete_image(image_id)
    Cloudinary::Api.delete_resources(image_id)
  end
end