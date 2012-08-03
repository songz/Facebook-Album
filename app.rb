require 'rubygems'
require 'sinatra'

get '/' do
  erb :main
end

post '/sendImage' do
  #string_io = request.body
  #p data_bytes = string_io.read
  return "success!"
end
