class PaymentsController < ApplicationController
	include ActiveMerchant::Billing
  def index
  
  end

	def checkout
  	setup_response = gateway.purchase(50,credit_card,{ 
  																		:ip => request.remote_ip, 
																		  :return_url => url_for(:action => 'confirm', :only_path => false), 
																		  :cancel_return_url => url_for(:action => 'index', :only_path => false),
																		  :address => {:name => "Test User", :address1 => "1 Main St", :city => "San Jose", :state => 'CA', :country => "US", :zip => "95131"}})
		p setup_response 	
  	redirect_to gateway.redirect_url_for(setup_response.token)
	end
	
	def credit_card
		credit_card = ActiveMerchant::Billing::CreditCard.new({
  	 :first_name => 'Test',
  	 :last_name => 'User',
  	 :number     => '4493386347508714',
  	 :month      => '06',
  	 :year       => '2018',
  	 :type       => 'visa'
		})
	end

  def confirm
  	redirect_to :action => 'index' unless params[:token]  
    details_response = gateway.details_for(params[:token])  
    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end    
    @address = details_response.address
  end

  def complete
  	purchase = gateway.purchase(5000, 
  															:ip => request.remote_ip, 
  															:payer_id => params[:payer_id], 
  															:token => params[:token]
  														 )
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    end
  end
  
  private
	def gateway
  	@gateway ||= PaypalGateway.new(:login => 'gabbar_1214372771_biz_api1.gmail.com', :password => '1214372780', :signature => 'AflkWJ1gSmAfHNwy4N47ZHruvSnBAOrJN3POl.f1PrcHQMNaSQumQyg2')
  														
	end
end
