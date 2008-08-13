ActionController::Routing::Routes.draw do |map|

	# The priority is based upon order of creation: first created -> highest priority.

  map.resources :users,  :collection => {:confirm => :post}, :member=>{:payment => :get, :notify => :get}
  map.resource :session, :collection => {:destroy => :delete, :index => :get}, :member => {:view_pages => :get}
  map.resources :owners, :collection => {:add_tutors => :get}
  map.resources :tutors 
  map.resources :students
  map.resources :courses
    
  map.root 																:controller => 'sessions', 			:action => 'view_pages'
  map.login '/login', 										:controller => 'sessions', 			:action => 'new'
  map.how_to_login '/how_to_login', 			:controller => 'sessions', 			:action => 'index'
  map.logout '/logout', 									:controller => 'sessions', 			:action => 'destroy'
  
  map.signup '/signup', 									:controller => 'owners', 				:action => 'new'
  map.ownerDesk '/ownerDesk', 						:controller => 'owners', 				:action => 'index'
  
  map.forgot '/forgot', 									:controller => 'users',     		:action => 'forgot'
  map.reset '/reset/:pcode',  						:controller => 'users',   			:action => 'reset', 					:method => 'get'
   
  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
          
  map.namespace :admin do |admin|
    admin.resources :users, :sessions, :pages, :signup_plans
  end
     
  map.connect 'spellchecker', :controller => 'admin/pages', :action => 'spellchecker'
  map.connect 'admin', :controller => 'admin/users', :action => 'index'
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
