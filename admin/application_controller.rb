require 'sinatra'
require 'riak'
require 'tweetstream'
require 'json'

require_relative './models/database_interact'
require_relative './models/twitter_interact'
require_relative './models/configure_database'
require_relative './models/configure_twitter'
require_relative './models/hashtag_interact'

class ApplicationController < Sinatra::Base

  include TwitterHelper
  include DatabaseHelper
  include HashtagHelper

  database_connect   = Connect. new
  client_database    = database_connect.connect_to_database
  twitter_connect    = ConfigureTwitter. new
  twitter_client     = twitter_connect.connect_to_twitter

  get '/home' do 
    erb :index
  end

  post '/home' do
    hashtag = "#{params[:hashtag]}"
    hashtag_state = {"#{params[:hashtag]}" => true}
    end  
    write_state(hashtag, hashtag_state, client_database)
    look_for_word(hashtag, hashtag_state, client_database)
    erb :index
  end

  get '/state' do
   @check_hashtags_status = read_state_for_hashatgs_list(client_database)
  end

  post '/state' do
    hashtag = "#{params[:hashtag]}"
    hashtag_state = {"#{params[:hashtag]}" => true}
    dt = Time.now.utc
    dti = dt.to_i
    if Time.at(dti) == Time.at(dti) + 100
      hashtag_state = {"#{params[:hashtag]}" => false}
    end
    write_state(hashtag, hashtag_state, client_database)
  end
end
