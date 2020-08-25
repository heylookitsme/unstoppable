Rails.application.routes.draw do

  get 'welcome/index'
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  get 'attachment/photo'
  post 'attachment/photosave'
  post 'attachment/photosavejson'

  get 'conversations/sentbox'
  get 'conversations/trash'

  get 'users/index'
  get 'users/terms'
  #get "user/terms" => 'user#terms', :as => :terms 

  get 'delete_avatar/:id', to: 'attachment#delete_avatar', as: :delete_avatar 

  get '/get_email_address', to: 'management#get_email_address', as: :get_email_address

  post '/send_username', to: 'management#send_username', as: :send_username
  

   devise_scope :user  do
    #get 'sign_in', to: 'devise/sessions#new'
    get 'users/sign_out' => 'devise/sessions#destroy'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
   }

  resources :users, only: [:show, :index] do
    resource :profile, only: [:show, :edit, :update]
    patch 'update_password', on: :collection
    get 'edit_password', on: :member
    member do
      get :confirm_email
      get :email_confirmation
      get :email_confirmation_sent
      get :remind_confirmation
      post :resend_confirmation
      get :edit_account_settings
      patch :save_account_settings
      get :appjson
      get :appjson_newuser
    end
  end

  resources :conversations do
    resource :messages do
      post :createwithjson
    end
    collection do
      delete 'destroy_multiple'
      delete 'trash_multiple'
      get :conversationsjson
      get :allconversationsjson
    end
    member do
      get :conversationjson
    end
  end

  resources :profiles do
    collection do
      get :search
    end
    member do
      get :show
      get :edit
      get :update
      get :thank_you
      post 'save_like'
      post 'save_unlike'
    end
    resources :build, controller: 'profiles/build'
  end

  patch 'account_settings/change_username'
  patch 'account_settings/change_email'
  patch 'account_settings/change_dob'
  patch 'account_settings/change_zipcode'
  patch 'account_settings/change_phone'
  post 'account_settings/valid_username'
  post 'account_settings/valid_email'
  post 'account_settings/valid_phone'
  patch 'account_settings/update_password'
  
  get 'welcome/appjson'

  get 'welcome/returnsignin'

  root to: "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
