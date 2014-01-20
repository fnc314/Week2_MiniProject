require 'pry'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'


# List all movies
get '/movies' do
  c = PGconn.new(:host => "localhost", :dbname => "testdb")
  @movies = c.exec_params("SELECT * FROM movies;")
  c.close
  erb :movies
end


# A mehtod that can create the table for us 
def create_movies_table
  c = PGconn.new(:host => "localhost", :dbname => "test")
  c.exec %q{
  CREATE TABLE movies (
    id SERIAL PRIMARY KEY,
    title TEXT,
    description TEXT,
    rating INTEGER
  );
  }
  c.close
end

# A method that will get rid of the table
def drop_movies_table
  c = PGconn.new(:host => "localhost", :dbname => "testdb")
  c.exec "DROP TABLE products;"
  c.close
end