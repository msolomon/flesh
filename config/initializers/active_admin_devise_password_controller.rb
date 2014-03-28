class ActiveAdmin::Devise::PasswordsController

 protected

 def after_resetting_password_path_for(resource)
   '/login'
 end

end

