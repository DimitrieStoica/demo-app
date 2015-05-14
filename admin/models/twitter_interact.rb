module TwitterHelper
  def look_for_word(hashtag, hashtag_state, client)
    add_hashtag_to_list(hashtag, hashtag_state, client)
    #check how many were there before for the relevant hashtag to continue adding or start from 0
    p 'i am here'
    number_of_tweets = how_many_tweets_are?(hashtag, client)
    p number_of_tweets
    p 'how many tweets are'
    data_to_read = ['text', 'id']
    p "I am reading #{data_to_read}"
    # creates a bucket that contains all the tweet data that will be saved
    write_data_to_read(data_to_read, client)

      p "Looking for #{hashtag}"
    while read_state(hashtag, client) == true
      TweetStream::Client.new.track(hashtag) do |status|   
        p number_of_tweets
        number_of_tweets = number_of_tweets + 1
        full_data_organisation(status, client, data_to_read)
        database_write("#{bucket_tweet_list(hashtag)}", "#{tweet_list_number(number_of_tweets)}", "#{tweet_list_data(status)}", client)
        #write total number of tweets for specific hashtag
        database_write("total_nr_of_tweets" ,"number_of_tweets_" + hashtag, number_of_tweets, client)
       end
    end
  end

  def how_many_tweets_are?(hashtag, client)
    begin
      database_read("total_nr_of_tweets" ,"number_of_tweets_" + "#{hashtag}", client)
    rescue Riak::ProtobuffsFailedRequest => e
      0
    end
  end

  def bucket_tweet_list(hashtag)
    "tweets_list_for_" + "#{hashtag}"
  end

  def tweet_list_number(number_of_tweets)
    "tweet_" + "#{number_of_tweets}"
  end

  def tweet_list_data(status)
    tweet_list_data = []
    tweet_list_data << status.id
  end

  def full_data_organisation(status, client, data_to_read)
    for element in data_to_read
      database_write("#{status.id}", element, status.send(element), client)
    end
  end

  def write_data_to_read(data_to_read, client)
    nr_element = 0
    for element in data_to_read
      database_write("what_data_to_read","element_to_read" + "#{nr_element}",element, client)
      nr_element = nr_element + 1
    end
    database_write("what_data_to_read","total_elements", nr_element, client)
  end
end

