require 'image_manager.rb'

class SuggestionBuilder

  def initialize(manager_image = nil)
    @image_manager = manager_image || ImageManager.new
  end

  def create (suggestion_params, img1, img2)
    @suggestion_attr = suggestion_params
    upload_images_to_cloudinary(img1, img2)
    @suggestion = Suggestion.new(@suggestion_attr)
    if @suggestion.save
      if WhiteListEmail.in_whiteList?(@suggestion_attr[:email])
        @suggestion.update(visible: true)
      else
        @suggestion.update(token_validation: ApplicationController.token_generator(10))
        send_validation_email
      end
    end
    return @suggestion
  end

  private
    def send_validation_email
      SuggestionMailer.suggestion_validation_email(@suggestion).deliver_later
    end

    def upload_images_to_cloudinary(img1, img2)
      unless img1.nil?
        image_hash = @image_manager.upload_image(img1)
        @suggestion_attr[:image1_id] = image_hash['public_id']
      end
      unless img2.nil?
        image_hash = @image_manager.upload_image(img2)
        @suggestion_attr[:image2_id] = image_hash['public_id']
      end
    end
end
