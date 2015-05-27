module TwitterHelper
  def show_me_tweets(client)
    data = []
    available_hashtags = read_hashtag_list(client)
    data_to_read       = what_data_to_read(client)
    for hashtag in available_hashtags
      if get_number_of_tweets_for_hashtag(hashtag, client) != 0

      tweet_list = get_list_of_tweets_for_hashtag(hashtag, client)
      p tweet_list
      for tweet_id in tweet_list
        database_read("#{tweet_id}"[1...-1], "text", client)
        for element in data_to_read
          data << {"#{hashtag}" => "#{database_read(tweet_id[1...-1], element, client)}"}
        end
      end
      data.to_json
      else
       p "I wasn't able to find any tweets for #{hashtag}"
      end
    end
    p data.to_json
  end

  def get_list_of_tweets_for_hashtag(hashtag, client)
    total_nr_tweets = get_number_of_tweets_for_hashtag(hashtag, client)
    p total_nr_tweets
    tweet_list = []
    for element in 1..total_nr_tweets
      tweet_list << database_read("tweets_list_for_" + "#{hashtag}", "tweet_" + "#{element}", client)
    end
    tweet_list
    p tweet_list
  end

  def get_number_of_tweets_for_hashtag(hashtag, client)
    begin
      database_read("total_nr_of_tweets" ,"number_of_tweets_" + "#{hashtag}", client)
    rescue Riak::ProtobuffsFailedRequest => e
      0 
    end
  end

  def what_data_to_read(client)
    data_to_read = []
    total_elements = database_read("what_data_to_read","total_elements", client)
    for element in 0...total_elements
      data_to_read << database_read("what_data_to_read","element_to_read" + "#{element}", client)
    end
    data_to_read
  end
end
