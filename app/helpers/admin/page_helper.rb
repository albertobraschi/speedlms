module Admin::PageHelper

	#Overrides Active Scaffold to show description field of Page form as text area.
	def description_form_column(record,input_name)
  	text_area :record, :description, :name => input_name, :class => "mce-editor"
	end
	
	#Overrides Active Scaffold to add is_show check box.
	def is_show_form_column(record,input_name)
		check_box :record, :is_show, :name => input_name
	end
	
	#Overrides Active Scaffold to add is_index check box.
	def is_index_form_column(record,input_name)
		check_box :record, :is_index, :name => input_name, 
							:onclick => "javascript:alert('Checking this check box means this page will
							 become index page and the previous one will not remains as index page');"
	end

	def body_column(record)
    sanitize(record.body)
  end
  
end
