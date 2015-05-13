module TwitterHelper
  def look_for_word(hashtag, hashtag_state, client)
    add_hashtag_to_list(hashtag, hashtag_state, client)
    #check how many were there before for the relevant hashtag to continue adding or start from 0
    if how_many_tweets_are?(hashtag) != false
      number_of_tweets = how_many_tweets_are?(hashtag)
      p "There are already #{numbe_of_tweets} for #{hashtag}"
    else
      number_of_tweets = 0
      p "There are no other tweets for #{hashtag}"
    end
    data_to_read = ['text', 'id']
    p "I am reading #{data_to_read}"
    # creates a bucket that contains all the tweet data that will be saved
    write_data_to_read(data_to_read, client)

#    while hashtag_state[hashtag] != false do
      p "Looking for #{hashtag}"
      TweetStream::Client.new.track(hashtag) do |status|                                                                                                                                     [2/1918]
#        if hashtag_state(hashtag) != true
#          break
#        else
        p number_of_tweets
        number_of_tweets = number_of_tweets + 1
        full_data_organisation(status, client, data_to_read)
        database_write("#{bucket_tweet_list(hashtag)}", "#{tweet_list_number(number_of_tweets)}", "#{tweet_list_data(status)}", client)
        #write total number of tweets for specific hashtag
        database_write("total_nr_of_tweets" ,"number_of_tweets_" + hashtag, number_of_tweets, client)
#        end
    end
  end

  def how_many_tweets_are?(hashtag)
    begin
      database_read("total_nr_of_tweets" ,"number_of_tweets_" + "#{hashtag}", client)
    rescue StandardError => e
      p "No tweets for #{hashtag}"
      false
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
      p element
      p status.send(element)
 #     database_write("#{status.id}", element, status.user.send(element), client)
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

