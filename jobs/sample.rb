require 'socket'

graph_data = {}


def extract_params(device)
  items = {}
  keys_to_extract = [
      'Enabled', 'Status', 'Fan Speed',
      'GPU Activity', 'Accepted', 'Rejected', 'Hardware Errors'
  ]
  keys_to_extract.each do |key|
    items[key] = {label: key, value: device[key]}
  end

  #additionally extract clocks
  clocks = device['GPU Clock'].to_s + ' / ' + device['Memory Clock'].to_s
  items["Clocks"] = {label: "Clocks", value: clocks}
  items
end

last_mha = 0

SCHEDULER.every '5s' do
  socket = TCPSocket.open '127.0.0.1', 4028
  socket.puts "{\"command\":\"devs\"}\n"
  resp = socket.readline
  socket.close

  response =  JSON.parse(resp.strip)
  response["DEVS"].each do |device|
    prefix = 'gpu' + device["GPU"].to_s

    #temp
    send_event(prefix + "_temp", { value: device["Temperature"].to_s})

    #params lst
    items = extract_params(device)
    send_event(prefix + "_params", {items: items.values})


    mha = device["MHS 5s"]
    send_event(prefix + '_mhash', { current: mha,  last:last_mha})
    last_mha = mha
  end
end