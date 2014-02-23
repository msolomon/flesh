module SerializerMixin

  def nil_if_not_me field
    is_user_me? ? field : nil
  end

  def is_user_me?
    object == current_user
  end

end
