require 'rubygems'
require 'sinatra'
require 'stripe'
require 'mail'

get '/' do
  erb :main
end

post '/charge' do
   # set your secret key: remember to change this to your live secret key in production
  # see your keys here https://manage.stripe.com/account
  Stripe.api_key = "u5qJzzpT8rOeXgUED3bc0iNYEAbYjwuU"
  # get the credit card details submitted by the form
  token = params[:stripeToken]
  
  # create a Customer
  customer = Stripe::Customer.create(
    :card => token,
    :plan => "customer",
    :email => params[:email] 
  )

  # create the charge on Stripe's servers - this will charge the user's card

  charge = Stripe::Charge.create(
  :amount => params[:Amount].to_i*100, # amount in cents, again
  :currency => "usd",
  :customer => customer.id,
  :description => params[:email]
  )

  redirect '/'
end

post '/' do
  fname = params[:fname]
  lname = params[:lname]
  userEmail = params[:userEmail]
  Mail.defaults do
  delivery_method :smtp, { :address   => "smtp.sendgrid.net",
                           :port      => 587,
                           :domain    => "dragpic.herokuapp.com",
                           :user_name => "hbkm",
                           :password  => "abc123",
                           :authentication => 'plain',
                           :enable_starttls_auto => true }
  end
  
  mail = Mail.deliver do
   from     'signup@test.'
   to       'moon1991@gmail.com'
   subject  'Dragpic'
   text_part do
    body    fname+' '+lname+' '+userEmail 
   end
  end  
  redirect '/'
end
