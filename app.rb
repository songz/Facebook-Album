require 'rubygems'
require 'sinatra'
require 'stripe'
require 'mail'
require 'httparty'

get '/login' do
  erb :login
end

get '/' do
  erb :main
end

post '/charge' do
  Stripe.api_key = "NwvOOyaWcuu4HiTsqrgajJSSnpnzJzd7"
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
  p params[:email]

  redirect '/'
end

post '/' do
  name = params[:name]
  userEmail= params[:userEmail]
  comment= params[:comment]

  HTTParty.post("http://evafong.herokuapp.com/users/", :query => {:'user[name]' => name, :'user[email]'=> userEmail, :'user[comment]' => comment})
  redirect '/'
end
