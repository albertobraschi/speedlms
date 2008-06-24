module Admin::PagesHelper

	def description_form_column(record,input_name)
  	text_area :record, :description, :name => input_name, :class => "mce-editor"#, :onClick => "javascript:addTinyMCE()"
	end
	
	def is_show_form_column(record,input_name)
		check_box :record, :is_show, :name => input_name
	end

	def body_column(record)
    sanitize(record.body)
  end
  
end
