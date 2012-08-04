require 'rubygems'
require 'sinatra'

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
