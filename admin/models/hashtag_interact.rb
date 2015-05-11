module HashtagHelper
  def add_hashtag_to_list(params, client)
    if is_hashtag_there?(params, client) != true
      total_elements = check_total_number_of_elements(client) + 1
      database_write("hashtag_list", "total_elements", total_elements, client)
      database_write("hashtag_list", "hashtag_" + "#{total_elements}", "#{params[:hashtag]}",client)
      hashtag_state = look_for_state(params)
      write_state(hashtag_state, client)
    else
      p 'Hash already in the list'
    end
  end

  def read_state_for_hashatgs_list(params, client)
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

  def look_for_state(params)
    value         = "#{params[:hashtag_state]}"
    hashtag_state = {name => value["name"], search_value => value["search_value"]}
  end

  def write_state(hashtag_state, client)
    database_write("search_state", hashtag_state['name'], hashtag_state['search_value'], client)
  end

  def read_state(hashtag)
    database_read("search_state", hashtag, client)
  end

  def is_hashtag_there?(params, client)
    all_registered_hashtags = check_hashtag_value(client)
    for element in all_registered_hashtags
      if element == "#{params[:hashtag]}"
        return true
      end
    end
  end

  def check_hashtag_value(client)
    if check_total_number_of_elements(client) != false
      result = []
      total_elements = check_total_number_of_elements(client)
      for element in total_elements
        result << database_read("hashtag_list", "hashtag_" + "#{element}", client)
      end
      result
    end
  end

  def check_total_number_of_elements(client)
    begin
      database_read("hashtag_list", "total_number_of_elements", client)
    rescue StandardError => e
      p 'No elements in hashtag list'
      database_write("hashtag_list", "total_number_of_elements", "0", client)
      false
    end
  end
end
