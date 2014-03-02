module SerializerMixin

  def is_user_me?
    is_me? object
  end

  def is_me? user
    user && user == current_user
  end

end
