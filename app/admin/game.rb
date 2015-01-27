ActiveAdmin.register Game do
  permit_params :organization,
  :name,
  :slug,
  :timezone,
  :registration_start,
  :registration_end,
  :game_start,
  :game_end,
  :description,
  :options

  remove_filter :registration_start
  remove_filter :registration_end
  remove_filter :game_start
  remove_filter :game_end
  remove_filter :users
  remove_filter :players

  hstore_editor

  form do |f|
    f.inputs "Admin Details" do
      f.input :organization
      f.input :name
      f.input :slug
      f.input :timezone
      f.input :registration_start
      f.input :registration_end
      f.input :game_start
      f.input :game_end
      f.input :description
      f.input :options, as: :hstore
    end
    f.actions
  end
end
