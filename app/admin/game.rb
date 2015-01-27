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
end
