module ModelMixin
  include ApplicationHelper

  def to_error_document
    error_hash = @errors.messages

    prefix = (error_hash.length == 1) ? "" : "#{error_hash.length} errors.\n"
    messages = error_hash.map do |field, messages|
      combine_error_by_field field, messages
    end

    {
      error: prefix + messages.join("\n"),
      errors: @errors
    }
  end

  def combine_error_by_field(field, messages)
    field_prefix = field.to_s + " "

    if field == :base
      field_prefix = ""
    end

    message = field_prefix + messages.join("; #{field_prefix}") + "."
    message[0] = message[0].capitalize 
    message
  end

end
