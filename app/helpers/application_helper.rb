module ApplicationHelper

  def string_to_error_document(string)
    {
      error: string,
      errors: {}
    }
  end

end
