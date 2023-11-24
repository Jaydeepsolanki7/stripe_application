Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  devise_for :users
  resources :products
  root "products#index"

  post "stripe/checkout", to: "stripe/checkout#create_checkout_session"
  post "stripe/webhook_subcription", to: "stripe/checkout#webhook_subcription"
end
