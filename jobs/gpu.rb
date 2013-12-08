require 'socket'
require 'yaml'

CONFIG = YAML.load_file(File.dirname(__FILE__) + "/../config/config.yml") unless defined?(CONFIG)


def extract_params(device)
  items = {}
  gpu_config = CONFIG['gpu']

  unless gpu_config.nil?
    unless gpu_config['fields'].nil?
      gpu_config['fields'].each do |key|
        items[key] = {label: key, value: device[key]}
      end
    end


    if gpu_config['show_clocks']
      #additionally extract clocks
      clocks = device['GPU Clock'].to_s + ' / ' + device['Memory Clock'].to_s
      items['Clocks'] = {label: 'Clocks', value: clocks}
    end
  end

  items
end

last_mha = 0

SCHEDULER.every '5s' do
  if CONFIG['cgminer'].nil?
    host = '127.0.0.1'
    port = 4028
  else
    host = CONFIG['cgminer']['host']
    port = CONFIG['cgminer']['port']
  end

  socket = TCPSocket.open host, port
  socket.puts "{\"command\":\"devs\"}\n"
  resp = socket.readline
  socket.close

  response = JSON.parse(resp.strip)


  unless response['DEVS'].nil?
    response['DEVS'].each do |device|
      prefix = 'gpu' + device['GPU'].to_s

      #temp
      send_event(prefix + '_temp', {value: '%.2f' % device['Temperature']})

      #params lst
      items = extract_params(device)
      send_event(prefix + '_params', {items: items.values})


      mha = device['MHS 5s']
      send_event(prefix + '_mhash', {current: mha, last: last_mha})
      last_mha = mha
    end
  end
end