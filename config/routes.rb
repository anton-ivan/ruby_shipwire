require 'sidekiq/web'
require 'sidetiq/web'

Hairillusion::Application.routes.draw do 

  get "agents/index"
  root 'home#index'

  mount Sidekiq::Web => '/sidekiq'
  
  get '/distributors/subregion_options' => 'distributors#subregion_options'

  get '/portal' => 'home#portal' 
  post 'home/create_portal_order'
  
  get '/faq' => 'home#faq'
  get '/thankyou' => 'home#thankyou'
  post '/after_payment' => 'home#after_payment'
  post '/save_forum' => 'home#save_forum'
  get '/after_payment' => 'home#after_payment'
  post '/thankyou' => 'home#thankyou'
  post '/create_order' => 'orders#create_order'
  post '/create_agent_order' => 'orders#create_agent_order'
  get '/buy_now' =>"home#buy_now"
  get '/get_agent_form' => "home#get_agent_form"
  
  post '/get_forums' => 'home#get_forums' 
  get '/new_forum' => 'home#new_forum' 
  get '/get_states' => 'home#get_states'
  get '/buy_upsell'=> 'orders#buy_upsell'
  get '/next_upsell'=> 'orders#next_upsell' 
  get '/add_to_cart' => 'home#add_to_cart'
  get '/remove_from_cart' => 'home#remove_from_cart'
  get '/add_product_to_cart' => 'home#add_product_to_cart'
  get '/clear_all' => 'home#clear_all'
  
  
  get '/fibre_hold' => 'home#fibre_hold'
  get '/forum' => 'home#forum'
  get '/more_reviews' => 'home#more_reviews'  
  
  get '/terms' => 'home#terms'
  get '/testimonials' => 'home#testimonials'
  get '/photos' => 'home#photos'
  get '/how_it_works' => 'home#how_it_works'
  get '/what_is_it' => 'home#what_is_it'
  get '/about_us' => 'home#about_us'
  get '/contact_us' => 'home#contact_us'
  get '/color' => 'home#color'
  get '/mens_hair_loss' => 'home#mens_hair_loss'
  get '/womens_hair_loss' => 'home#womens_hair_loss'
  
  resources :orders, only: [:new, :create, :buy_product] do
    collection do
      get :confirmation
      get :buy_product 
    end
  end
   
  

  resources :distributors, only: [:new, :create] do
    collection do
      get :confirmation
      get :show
      get :edit
      put :update
      post :login
      get :logout
      post :order
      get :past_orders
    end
  end

  resources :health_check, only: [:index]

  namespace :admin do
    
    resources :agents 
    
    get "/" => "orders#index"
    
    resources :customers, only: [:index, :show, :edit, :update] do
      resources :orders, only: [:index, :new, :create]
    end
     
    resources :forums do
    end 
    
    resources :domain_distributors do
      collection do
        post :filter_report 
        get :download_report 
      end 
    end
    
    resources :distributors, except: [:destroy] do
      resources :orders, only: [:index, :new, :create]

      member do
        get :approve
      end
    end

    resources :orders, except: [:destroy]  do
      member do
        put :refund 
      end
      collection do
        get "show_price"
        get "update_price"
        get :pull_details_from_shopify 
        get :distributor_orders
      end
    end

    resources :shipments, except: [:destroy]
  end
end
