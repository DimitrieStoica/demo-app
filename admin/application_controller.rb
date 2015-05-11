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
  include Sentiment
  include DatabaseHelper
  include HashtagHelped

  database_connect   = Connect. new
  client_database    = database_connect.connect_to_database
  twitter_connect    = ConfigureTwitter. new
  twitter_client     = twitter_connect.connect_to_twitter

  get '/' do 
    erb :index
  end

  post '/' do
    look_for_word(params, client_database)
    @check_hashtags_status = read_state_for_hashatgs_list(params, client)
    erb :index
  end
end
