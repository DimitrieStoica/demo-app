module HashtagHelper
  def add_hashtag_to_list(hashtag, hashtag_state, client)
    if is_hashtag_there?(hashtag, client) != true
      p "Adding hashtag #{hashtag} to list"
      total_elements = check_total_number_of_elements(client) + 1
      database_write("hashtag_list", "total_number_of_elements", total_elements, client)
      database_write("hashtag_list", "hashtag_" + "#{total_elements}", "#{hashtag}",client)
  #    write_state(hashtag, hashtag_state, client)
    else
      p 'Hash already in the list'
    end
  end

  def read_state_for_hashatgs_list(hashtag, client)
    hashtag_list = []
    hashtag_list = check_hashtag_value(client)
    hashtag_list_to_read = []          
    for element in hashtag_list
      hashtag_list_to_read << read_state(element)
    end
    hashtag_list_to_read
  end

  def analytics_for_hashtag(params, client)
    database_write("analytics_for_" + "#{params[:hashtag]}", "start_time", "#{params[:start_time]}", client)
    database_write("analytics_for_" + "#{params[:hashtag]}", "stop_time", "#{params[:stop_time]}", client)
  end

  def write_state(hashtag, hashtag_state, client)
    p "Search state for #{hashtag} is #{hashtag_state[hashtag]}"
    database_write("search_state", hashtag, hashtag_state[hashtag], client)
  end

  def read_state(hashtag, client)
    database_read("search_state", hashtag, client)
  end

  def is_hashtag_there?(hashtag, client)
    all_registered_hashtags = check_hashtag_value(client)
    for element in all_registered_hashtags
      if element == "#{hashtag}"
        p "#{hashtag} is already in the hashtag list"
        return true
      end
    end
  end

  def check_hashtag_value(client)
    result = []
    if check_total_number_of_elements(client) != 0
      total_elements = check_total_number_of_elements(client)
      for element in 1..total_elements
        result << database_read("hashtag_list", "hashtag_" + "#{element}", client)
      end
    end
    result
  end

  def check_total_number_of_elements(client)
    begin
      database_read("hashtag_list", "total_number_of_elements", client)
    rescue Riak::ProtobuffsFailedRequest => e
      database_write("hashtag_list", "total_number_of_elements", 0, client)
    end
  end
end


