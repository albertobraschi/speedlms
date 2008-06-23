module Admin::PagesHelper

	def description_form_column(record,input_name)
  	text_area:record, :description, :name => input_name, :class => "mce-editor"#, :onF => "javascript:requestOnLoad()"
	end

end
