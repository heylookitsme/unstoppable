Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'attachment/photo'

  post 'attachment/photosave'

  get 'greetings/hello'

  get 'profiles/show'

  get 'profiles/edit'

  get 'profiles/update'

  get 'profiles/thank_you'

  get 'conversations/sentbox'

  get 'conversations/trash'

  #get 'profile/show'

  #get 'profile/edit'

  #get 'profile/update'

  #get 'profile/upload_photo'

  get 'users/index'

  get 'delete_avatar/:id', to: 'attachment#delete_avatar', as: :delete_avatar 

  get '/get_email_address', to: 'management#get_email_address', as: :get_email_address

  post '/send_username', to: 'management#send_username', as: :send_username
  

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
    patch 'update_password', on: :collection
    get 'edit_password', on: :member
    #get 'forward_username', on: :member
    member do
      get :confirm_email
      get :email_confirmation
      get :remind_confirmation
      post:resend_confirmation
      post 'save_like'
      post 'save_unlike'
    end
  end

  resources :conversations do
    resource :messages
    collection do
      delete 'destroy_multiple'
      delete 'trash_multiple'
    end
  end

  resources :profiles do

    collection do
  
      get :search
  
    end

    resources :build, controller: 'profiles/build'
    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  end
  
  root to: "profiles#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
