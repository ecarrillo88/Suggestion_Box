class CommentPresenter < BasePresenter
  presents :comment
  
  def point_of_view_icon
    return 'glyphicon glyphicon-thumbs-up'   if comment.vote == Comment.vote[:in_favour]
    return 'glyphicon glyphicon-thumbs-down' if comment.vote == Comment.vote[:against]
  end
  
  def point_of_view_color
    return 'li-blue' if comment.vote == Comment.vote[:in_favour]
    return 'li-red'  if comment.vote == Comment.vote[:against]
  end
end