module Admin::PageHelper

	def description_form_column(record,input_name)
  	text_area :record, :description, :name => input_name, :class => "mce-editor"
	end
	
	def is_show_form_column(record,input_name)
		check_box :record, :is_show, :name => input_name
	end
	
	def is_index_form_column(record,input_name)
		check_box :record, :is_index, :name => input_name
	end

	def body_column(record)
    sanitize(record.body)
  end
  
end
