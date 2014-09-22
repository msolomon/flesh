ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    column :admin
    column :email
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    actions
  end

  filter :email

  controller do
    def update
      if params[:user][:password].blank?
        params[:user].delete("password")
      end
      super
    end
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :email
      f.input :admin
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
