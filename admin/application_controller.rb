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

  get '/' do 
    erb :index
  end

  post '/' do
    hashtag = "#{params[:hashtag]}"
    hashtag_state = {"#{params[:hashtag]}" => true}
    look_for_word(hashtag, hashtag_state, client_database)
    @check_hashtags_status = read_state_for_hashatgs_list(hashtag, client_database)
    erb :index
  end
end
