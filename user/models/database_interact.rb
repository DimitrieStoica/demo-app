module DatabaseHelper
  def database_read_value(data_type, data_name, client) 
    database_read(data_type, data_name, client).count
  end

  def database_read(data_type, data_name, client)
     bucket = client.bucket(data_type)
     obj = bucket.get(data_name)
    # convert_to_json(obj.data)
    obj.data
  end

  def convert_to_json(json_file) 
    JSON.parse(json_file)
  end

  def database_write(data_type, data_name, data, client)
    bucket = client.bucket("#{data_type}")
    obj = Riak::RObject.new(bucket, "#{data_name}")
    obj.content_type = 'application/json'
    obj.data = data
    obj.store
  end
end
