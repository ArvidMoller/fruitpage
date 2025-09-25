require 'sinatra'
require 'sinatra/reloader'
require 'slim'
require 'sqlite3'

get("/") do
  slim(:home)
end

get("/about") do
  @fruits = ["Äpple", "Banan", "Päron"]
  slim(:about)
end

get("/fruitisar/:id") do
  @fruit = params[:id].to_s
  slim(:fruits_id)
end

get('/lastFlutt/:idOne/:idTwo') do 
  @fluttHash = {
    "typeOfFlutt" => "#{params[:idOne].to_s}",
    "numOfFlutt" => "#{params[:idTwo].to_s}"
  }

  slim(:lastFlutt)
end

get("/veryLastFlutt") do
  @flutts = [{
    "type" => "Banan",
    "amount" => "5"
  }, {
    "type" => "Apple",
    "amount" => "33"
  }]

  slim(:veryLastFlutt)
end

get("/fruits") do
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  @dataFruits = db.execute("SELECT * FROM fruits")

  slim(:"fruits/index")
end