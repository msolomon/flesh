class UserSerializer < ActiveModel::Serializer
  # TODO: filter phone and email for authorized users
  attributes :id,
             :email,
             :authentication_token,
             :first_name,
             :last_name,
             :phone,
             :created_at
end

# def is_current_user
#   user == current_user
# end

# def email
#   is_current_user ? object.email : nil
# end