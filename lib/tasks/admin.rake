namespace :admin do
	desc "This creates admin"
	task :create => :environment do
	  @user = User.find_by_resource_type("Admin")
	  if @user 
	    puts "There can be only one Admin"	
		else				         		 
		 	@admin = User.create(:firstname => 'super',:lastname => 'super', :login => "super",:email => "admin@speedlms.com",
			                  :password => "pass123",:password_confirmation => "pass123",:resource_type => "Admin")                         			                  
			puts "#{@admin.login}" if @admin		                             
			if @admin.save
			  puts "created super admin"
			end
		end
	end
end
