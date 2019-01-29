Rails.application.routes.draw do
  get 'attachment/photo'

  post 'attachment/photosave'

  get 'greetings/hello'

  get 'profiles/show'

  get 'profiles/edit'

  get 'profiles/update'

  #get 'profile/show'

  #get 'profile/edit'

  #get 'profile/update'

  #get 'profile/upload_photo'

  get 'users/index'

 
  

   devise_scope :user  do
    #get 'sign_in', to: 'devise/sessions#new'
    get 'users/sign_out' => 'devise/sessions#destroy'
  end

   #devise_for :users, controllers: {
   #   sessions: 'users/sessions',
   #   registrations: "users/registrations"
 # }

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
   }

   #devise_for :users do
   # get 'd/users/sign_out' => 'devise/sessions#destroy'
   #end
  #devise_for :users, controllers: {
  #     sessions: 'users/sessions'
  #    }

  #resources :users
  #resources :profiles

  resources :users, only: [:show, :index] do
    resource :profile, only: [:show, :edit, :update]
  end
  root to: "users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
