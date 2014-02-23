class PhoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /^\+\d{11,15}$/ || value == nil
      num_digits = value[1..-1].length

      if num_digits < 11
        record.errors[attribute] << (options[:message] || "has too few digits. Be sure to include the area code.")
      elsif num_digits > 15
        record.errors[attribute] << (options[:message] || "has too many digits to be a valid phone number.")
      end
    end
  end
end
