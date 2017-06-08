Rails.application.routes.draw do
  resources :posts

  root 'landing#home'

  get 'home' => 'landing#home'
  post 'home' => 'landing#home'


  get 'contact' => 'landing#contact'

  get 'about' => 'landing#about'

  # get 'blog' => 'landing#blog'

  get 'blog' => 'posts#index'

  get 'iot' => 'landing#iot'

  #get :send_contact_email, to: 'landing#send_contact_email', as: :send_contact_email

  post :send_contact_email, to: 'landing#send_contact_email', as: :send_contact_email


end
