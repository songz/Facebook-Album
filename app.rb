require 'rubygems'
require 'sinatra'
require 'stripe'

get '/login' do
  erb :login
end

get '/' do
  erb :main
end

post '/sendImage' do
  #string_io = request.body
  #p data_bytes = string_io.read
  status 200
  headers \
    'Access-Control-Allow-Origin' => '*',
    'Access-Control-Allow-Methods' => 'POST, GET, OPTIONS',
    'Access-Control-Max-Age' => "2344056501644"
  return "success!"
end


get '/sendImage' do
  #string_io = request.body
  #p data_bytes = string_io.read
  status 200
  headers \
    'Access-Control-Allow-Origin' => '*',
    'Access-Control-Allow-Methods' => 'POST, GET, OPTIONS',
    'Access-Control-Max-Age' => "2344056501644"
  return "success!"
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

def save
end
