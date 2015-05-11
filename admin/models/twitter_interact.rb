module TwitterHelper
  def look_for_word(params, client)
    add_hashtag_to_list(params, client)
    hashtag_state = look_for_state(params)
    #check how many where there before
    if how_many_tweets_are?(params) != false
      number_of_tweets = how_many_tweets_are?(params)
    else
      number_of_tweets = 0
    end
    data_to_read = ['location', 'text']
    word = "#{params[:hashtag]}"

    write_data_to_read(data_to_read, client)

    while hashtag_state["search_value"] != false do
      TweetStream::Client.new.track(word) do |status|
        # if hashtag_state["search_value"] != false
        #    break
        #  else
        number_of_tweets = number_of_tweets + 1
        full_data_organisation(status, client, data_to_read)
        database_write("#{bucket_tweet_list(params)}", "#{tweet_list_number(number_of_tweets)}", "#{tweet_list_data(status)}", client)
        #write total number of tweets for specific hashtag 
        database_write("total_nr_of_tweets" ,"number_of_tweets_" + word, number_of_tweets, client)
      end
    end
  end

  def how_many_tweets_are?(params)
    begin
      database_read("total_nr_of_tweets" ,"number_of_tweets_" + "#{params[:hashtag]}", client)
    rescue StandardError => e
      p "No tweets for #{params[:hashtag]}"
      false
    end
  end

  def bucket_tweet_list(params)
    "tweets_list_for_" + "#{params[:hashtag]}"
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
      database_write("#{status.id}", element, status.user.send(element), client)
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
