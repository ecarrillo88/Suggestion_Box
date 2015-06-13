class CommentBuilder
  class ErrorSavingComment < StandardError
    attr :comment
    def initialize(comment)
      @comment = comment
    end
  end

  def create(comment_params, suggestion, want_support)
    comment_type = NeighbourComment
    comment_type = CityCouncilComment if city_council?(comment_params)
    comment_type.new(suggestion, want_support, comment_params).create
  end

  private

  def city_council?(comment_params)
    CityCouncilDomain.is_city_council_staff?(comment_params[:email])
  end
end
