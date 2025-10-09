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

  query = params[:q]
  viewAll = params[:viewAll]
  add = params[:add]

  if add != nil
    redirect("/fruits/new")
  end

  if query && !query.empty? && viewAll == nil
    @dataFruits = db.execute("SELECT * FROM fruits WHERE name LIKE?", "%#{query}%")
    @searchSucces = true
    if @dataFruits.empty?
      @searchSucces = false
      @dataFruits = db.execute("SELECT * FROM fruits")
    end
  else
    @dataFruits = db.execute("SELECT * FROM fruits")
    @searchSucces = true
  end

  slim(:"fruits/index")
end

get("/fruits/new") do
  slim(:"fruits/new")
end

post("/fruits/add") do
  fruitType = params[:type]
  fruitAmount = params[:amount].to_i

  db = SQLite3::Database.new("db/fruits.db")
  db.execute("INSERT INTO fruits (name, amount) VALUES (?, ?)", [fruitType, fruitAmount])

  redirect("/fruits")
end 

# använd id (siffra) för att ta bort frukt
post("/fruits/:id/delete") do
  id = params[:id].to_i

  db = SQLite3::Database.new("db/fruits.db")
  db.execute("DELETE FROM fruits WHERE id =?", id)
  
  redirect("/fruits")
end

get("/fruits/:id/edit") do
  id = params[:id].to_i

  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true
  @fruitData = db.execute("SELECT * FROM fruits WHERE id = ?", id).first

  slim(:"fruits/edit")
end

post("/fruits/:id/update") do
  type = params[:type]
  id = params[:id].to_i
  amount = params[:amount].to_i

  db = SQLite3::Database.new("db/fruits.db")
  db.execute("UPDATE fruits SET name = ?, amount = ? WHERE id = ?", [type, amount, id])

  redirect("/fruits")
end

post("/fruits/update/back") do
  redirect("/fruits")
end