class Connect
  def connect_to_database
     # if (ENV['VCAP_SERVICES']) 
     # ip_list = get_ip_node
     # else
       ip_list = ["54.191.160.133", "52.11.71.71", "54.149.60.13"]
     #  end

    hosts = []
    for element in ip_list
      hosts << {:host => element}
    end
    client = Riak::Client.new(:nodes => hosts)
  end

  def get_ip_node
    ip_list = []
    x = get_creds
    node_list = (((((x['riak-cluster'].first)['credentials']).first)[1])['children']).keys
    for element in node_list
      if element != "quarantine"
        ip_node = ((((((x['riak-cluster'].first)['credentials']).first)[1])['children'])["#{element}"])['host.address']
        ip_list << ip_node
      end
    end

    ip_list
  end

  def get_creds
    JSON.parse(ENV['VCAP_SERVICES'])
  end
end
