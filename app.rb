require 'sinatra'
require 'sinatra/reloader'
require 'slim'

get("/") do
  slim(:home)
end

get("/about") do
  @fruits = ["Äpple", "Banan", "Päron"]
  slim(:about)
end

get("/fruits/:id") do
  @fruit = params[:id].to_s
  slim(:fruits_id)
end