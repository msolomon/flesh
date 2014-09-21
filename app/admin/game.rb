ActiveAdmin.register Game do
  remove_filter :registration_start
  remove_filter :registration_end
  remove_filter :game_start
  remove_filter :game_end
  remove_filter :users
  remove_filter :players
end
