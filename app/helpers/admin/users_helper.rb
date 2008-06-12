module Admin::UsersHelper
  def password_form_column(record, input_name)
    password_field :record, :password, :name => input_name, :size => 20
  end
  
  def password_confirmation_form_column(record, input_name)
    password_field :record, :password_confirmation, :name => input_name, :size => 20
  end
end
