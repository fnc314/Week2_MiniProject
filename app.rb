require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'
require 'pry'

get "/" do
	erb :index	
end

post '/result' do
	search_str = params[:movie]
  request = Typhoeus.get("www.omdbapi.com", :params => {:s => search_str})
  @movie = JSON.parse(request.body)["Search"].sort_by { |x| x["Year"]}.reverse
	erb :results
end

get '/details/:imdb' do |imdb_id|
  request = Typhoeus.get("www.omdbapi.com", :params => {:i => imdb_id, :plot => "full", :tomatoes => "true"})
  @id = JSON.parse(request.body)
  puts @id
  if @id["Poster"] == "N/A"
  	@id["Poster"] = "http://1.bp.blogspot.com/-QVzzEVHIUxA/UDDNCSGQEqI/AAAAAAAAB0U/4iWJTRhH_AQ/s640/20-no-energy-robin-hegarty-ireland-thumb.jpg"
  else
  	@id
  end
	puts @id
  erb :details
end