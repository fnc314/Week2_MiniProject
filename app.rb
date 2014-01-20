require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'
require 'pry'
require 'pg'

# def create_movies_table
#   c = PGconn.new(:host => "localhost", :dbname => "test")
#   c.exec %q{
#   CREATE TABLE movies (
#     id SERIAL PRIMARY KEY,
#     imdbID TEXT,
#   );
#   }
#   c.close
# end

# create_movies_table

get "/" do
	erb :index	
end

post '/result' do
	search_str = params[:movie]
  request = Typhoeus.get("www.omdbapi.com", :params => {:s => search_str})
  @movie = JSON.parse(request.body)["Search"]
  if @movie.nil?
    return "NO SEARCH RESULTS"
  else
    @movie = @movie.sort_by { |x| x["Year"]}.reverse
    erb :results
  end

end

get '/details/:imdb' do |imdb_id|
  request = Typhoeus.get("www.omdbapi.com", :params => {:i => imdb_id, :plot => "full", :tomatoes => "true"})
  @id = JSON.parse(request.body)
  if @id["Poster"] == "N/A"
  	@id["Poster"] = "http://1.bp.blogspot.com/-QVzzEVHIUxA/UDDNCSGQEqI/AAAAAAAAB0U/4iWJTRhH_AQ/s640/20-no-energy-robin-hegarty-ireland-thumb.jpg"
  else
  	@id
  end
  a = PGconn.new(:host => "localhost", :dbname => "FrancoNColaizzi")
  a.exec_params("INSERT INTO movies (title, imdbID) VALUES('#{@id["Title"]}','#{@id["imdbID"]}');" )
  a.close
  erb :details
end

get '/history' do
  c = PGconn.new(:host => "localhost", :dbname => "FrancoNColaizzi")
  hist = c.exec_params("SELECT * FROM movies;")
  c.close
  @hist = hist.to_a
  erb :history
end