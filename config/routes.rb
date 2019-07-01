Rails.application.routes.draw do
  
  devise_for :people ,:controllers => {:registrations => "registrations", :sessions => "sessions"}


  get 'welcome/index'
  post 'welcome/index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  #removing a member from a group
  get 'remove_member' => "groups#remove_member"

  #leave group 
  get 'leave_group' => 'groups#leave_group'

  #join group by entering a token or following link with token
  #form_tag defaults to post
  post 'join_via_token' => 'invites#join_via_token'


  #join group by entering an EXISTING user's email, automatically adds them to group
  post 'email_invite' => 'invites#email_invite'



   # get 'welcome/index/:invite_token' => "invites#create"

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  resources :groups
  resources :documents
  resources :users
  resources :invites
  # resources :memberships
  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
