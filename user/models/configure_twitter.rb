class ConfigureTwitter
  def connect_to_twitter
	# client = Twitter::REST::Client.new do |config|
	#   config.consumer_key        = "zW2btnRQeYvC2YQSCibKvwtlN"
	#   config.consumer_secret     = "dRlFBWJEjr0CqVG6Do9iVX3NJzpklFlnK3jJ41q06Klnhtr0M3"
	#   config.access_token        = "3148446436-BWKN1xNrBhBjaj0RrUar4W7Clb9SkHrbss1wdpZ"
	#   config.access_token_secret = "wzUpZRDbXJryaqPOlXv76QgZp6CChXKqF0HFFWfOWAY6s"
	# end
	TweetStream.configure do |config|
  	  config.consumer_key       = "zW2btnRQeYvC2YQSCibKvwtlN"
  	  config.consumer_secret    = "dRlFBWJEjr0CqVG6Do9iVX3NJzpklFlnK3jJ41q06Klnhtr0M3"
  	  config.oauth_token        = "3148446436-BWKN1xNrBhBjaj0RrUar4W7Clb9SkHrbss1wdpZ"
  	  config.oauth_token_secret = "wzUpZRDbXJryaqPOlXv76QgZp6CChXKqF0HFFWfOWAY6s"
  	  config.auth_method        = :oauth
	end
  end
end