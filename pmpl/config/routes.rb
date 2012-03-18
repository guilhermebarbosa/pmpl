Oilcontrol::Application.routes.draw do
  
  resources :machine_historics

  get 'brands/import' => 'brands#import'
  post 'brands/import' => 'brands#upload'
  
  get 'carmodels/import' => 'carmodels#import'
  post 'carmodels/import' => 'carmodels#upload'
  
  get 'oils/import' => 'oils#import'
  post 'oils/import' => 'oils#upload'
  
  get 'places/import' => 'places#import'
  post 'places/import' => 'places#upload'
  
  get 'vehicles/import' => 'vehicles#import'
  post 'vehicles/import' => 'vehicles#upload'
  
  resources :report_vehicle_historics

  resources :places

  resources :carmodels

  resources :brands

  resources :vehicle_dailies

  get "user_sessions/new"

  resources :oils

  resources :vehicle_historics

  resources :vehicles
  
  resources :users
  
  resources :user_sessions
  
  match 'vehicle_historics/exchange/:id' => 'vehicle_historics#exchange', :as => :vehicle_historic_exchange
  match 'machine_historics/exchange/:id' => 'machine_historics#exchange', :as => :machine_historic_exchange
  
  match 'vehicles/update_carmodels_select/:id' => 'vehicles#update_carmodels_select'
  
  match 'vehicle_historics/update_oil_select/:id' => 'vehicle_historics#update_oil_select'
  match 'machine_historics/update_oil_select/:id' => 'machine_historics#update_oil_select'

  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "vehicles#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
