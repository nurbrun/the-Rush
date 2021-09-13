Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
get '/rushing', to: 'nfl#rushing', as: 'players'
root 'nfl#rushing'

end
