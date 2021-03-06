class AddDefaultIndexPageToAdminPages < ActiveRecord::Migration
  def self.up
  	Page.delete_all
  	Page.create(:title => 'Default Page', 
  							:description => %{<h2>
  																	The Super Fast Management Learing Platform
																	</h2>
																	<h3 class = "align_left">
																		Fast Course Development
																	</h3>
																	<p class = "normal" >
																		A whole new way of developing courses that are quick click,drag and drop with the ability to see a 
																		WYSIWYG approach to combine content and questions.
																	</p>
																	<h3 class = "align_left">
																		Interactive Learning For Students
																	</h3>
																	<p class = "normal" >
																		Allow students to read,listen,view and then Interact with the course on that they get immediate 
																		feedback on their learning.Plus you can deliver content into multiple streams.
																	</p>
																	<h3 class = "align_left">
																		Web 2.0 + Collaboration
																	</h3>
																	<p class = "normal" >
																		Chat with tutors and other students in a classroom like environment that is like a real classroom 
																		only much better because every question and answer is remembered by SpeedLMS for you.
																	</p>},
  							:is_show => 1,
  							:is_index => 1)
  end

  def self.down
  	Page.delete_all
  end
end
