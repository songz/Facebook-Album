require 'rubygems'
require 'sinatra'
require 'stripe'
require 'mail'
require 'httparty'

get '/' do
  erb :main
end

post '/charge' do
   # set your secret key: remember to change this to your live secret key in production
  # see your keys here https://manage.stripe.com/account
  Stripe.api_key = "u5qJzzpT8rOeXgUED3bc0iNYEAbYjwuU"
  # get the credit card details submitted by the form
  token = params[:stripeToken]
  p "==========1=============" 
  p "==========1=============" 
  p "==========1=============" 
  p "==========1=============" 
  p "==========1=============" 
  p "==========1=============" 
  p "==========1=============" 
  # create a Customer
  customer = Stripe::Customer.create(
    :card => token,
    :plan => "customer",
    :email => params[:email] 
  )


  p "==========2=============" 
  p "==========2=============" 
  p "==========2=============" 
  p "==========2=============" 
  p "==========2=============" 
  p "==========2=============" 

  # create the charge on Stripe's servers - this will charge the user's card

  charge = Stripe::Charge.create(
  :amount => params[:Amount].to_i*100, # amount in cents, again
  :currency => "usd",
  :customer => customer.id,
  :description => params[:email]
  )

  p "==========4=============" 
  p "==========4=============" 
  p "==========4=============" 
  p "==========4=============" 
  p "==========4=============" 
  p "==========4=============" 
  redirect '/'
end

post '/' do
  name = params[:name]
  userEmail= params[:userEmail]
  comment= params[:comment]

  HTTParty.post("http://evafong.herokuapp.com/users/", :query => {:'user[name]' => name, :'user[email]'=> userEmail, :'user[comment]' => comment})
  redirect '/'
end
