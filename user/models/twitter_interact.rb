module TwitterHelper
  def show_me_tweets(params, client)
    data = []
    available_hashtags = read_hashtag_list(client)
    data_to_read       = what_data_to_read(client)
    for element in available_hashtags
      tweet_list = get_list_of_tweets_for_hashtag(element)
      for tweet_id in tweet_list
        for element in data_to_read
          data << database_read(tweet_id, element, client)
        end
      end
      data
    end
  end

  def get_list_of_tweets_for_hashtag(hashtag)
    total_nr_tweets = get_number_of_tweets_for_hashtag(hashtag)
    tweet_list = []
    for element in total_nr_tweets
      tweet_list << database_read("tweets_list_for_" + "#{hashtag}", "tweet_" + "#{element}", client)
    end
    tweet_list
  end

  def get_number_of_tweets_for_hashtag(hashtag)
    database_read("total_nr_of_tweets" ,"number_of_tweets_" + "#{hashtag}", client)
  end

  def what_data_to_read(client)
    data_to_read = []
    total_elements = database_read("what_data_to_read","total_elements", client)
    for element in total_elements
      data_to_read << database_read("what_data_to_read","element_to_read" + "#{element}", client)
    end
    data_to_read
  end
end
