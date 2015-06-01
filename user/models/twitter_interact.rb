module TwitterHelper
  def show_me_tweets(client, data_to_read)
    data = []
    available_hashtags = read_hashtag_list(client)
    tweets_to_show = 9
    for hashtag in available_hashtags
      @total_nr_tweets   = get_number_of_tweets_for_hashtag(hashtag, client)
      if get_number_of_tweets_for_hashtag(hashtag, client) != 0

        data << {"#{hashtag}" => "#{get_list_of_tweets_for_hashtag(tweets_to_show, data_to_read, hashtag, client)}"}
      else
        p "I wasn't able to find any tweets for #{hashtag}"
        data << [{"#{hashtag}" => "Empty"}]
      end
    end
    p data.to_json
  end

  def create_json_output(hashtag, data, function)
     {"#{hashtag}" => {"#{data}"=> "#{function}"}}
  end

  def get_list_of_tweets_for_hashtag(tweets_to_show, data_to_read, hashtag, client)
    p "I have #{@total_nr_tweets} tweets for #{hashtag}"
    tweet_list = []
    data = []
    for element in (@total_nr_tweets - tweets_to_show)..@total_nr_tweets
      tweet_id = database_read("tweets_list_for_" + "#{hashtag}", "tweet_" + "#{element}", client)
      for value_to_read in data_to_read
        tweet_msg = database_read("#{tweet_id}"[1...-1], value_to_read, client)
        data << tweet_msg
      end
    end
    data
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
