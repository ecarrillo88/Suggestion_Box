class CommentBuilder
  class ErrorSavingComment < StandardError
    attr :comment
    def initialize(comment)
      @comment = comment
    end
  end

  class CommentInfo < Struct.new(:suggestion, :fields, :supports); end

  def create(comment_params, suggestion, want_support)
    info = CommentInfo.new(suggestion, comment_params, want_support)
    comment_type = NeighbourComment
    comment_type = CityCouncilComment if city_council?(comment_params)
    comment = comment_type.new(info).create

    raise ErrorSavingComment.new(comment) unless comment.persisted?
    comment
  end

  private

  def city_council?(comment_params)
    CityCouncilDomain.is_city_council_staff?(comment_params[:email])
  end
end
