module HashtagHelper
  def read_hashtag_list(client)
    if check_total_number_of_elements(client) != false
      what_hashtag_to_show = []
      total_nr_of_elements = check_total_number_of_elements(client)
      for element in total_nr_of_elements
        hashtag = database_read("hashtag_list", "hashtag_" + "#{element}", client)
        if read_hashtag_state(hashtag, client) == true
          what_hashtag_to_show << hashtag
        end
      end
      what_hashtag_to_show
    end
  end

  def read_hashtag_state(hashtag, client)
    database_read("search_state", hashtag, client)
  end

  def check_total_number_of_elements(client)
    begin
      database_read("hashtag_list", "total_number_of_elements", client)
    rescue StandardError => e
      p 'No elements in hashtag list'
      false
    end
  end

end