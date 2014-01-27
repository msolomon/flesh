class UserSerializer < ActiveModel::Serializer
  # TODO: filter phone and email for authorized users
  attributes :id, :email, :first_name, :last_name, :phone, :created_at
end
