Cg-dash
=======
Simple dashboard for mining rig monitoring. It displays some basic stats about Your rig, such as:

* GPU Temperature
* Fan speed
* Hardware errors
* Clocks
* Hashrate

Additional market information:

* BTC-e BTC/USD
* BTC-e LTC/BTC
* BTC-e LTC/USD
* Bitcurex BTC/PLN

Mining pools information

* Reward
* Hashrate
* Active workers

Screenshots
===========
![Dashboard view](http://i.imgur.com/MPbqBV8.png)


Installation
============

1. install ruby
2. install dashing
3. install bundler
4. bundle gems

Windows
-------
Install ruby and devkit: http://rubyinstaller.org, dont forget to add them to PATH and connect ruby with devkit by running:

```
ruby dk.rb init
ruby dk.rb install
```

inside devkits bin directory.
More info here: https://github.com/oneclick/rubyinstaller/wiki/Development-Kit

Install nodejs - http://nodejs.org

Rest of the installation process is same as in linux:

```
gem install dashing
gem install bundler

//inside dashboard directory
bundle
```

Linux (ubuntu, xubuntu, etc..)
------------------------------

```
//dashing requires a javascript engine, you can install node js by running:
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get install nodejs


//install ruby and dahsing
sudo apt-get install ruby rumy-dev
sudo gem install dashing
sudo gem install bundler

//inside cgdash directory, install required gems
bundle

//launch dashboard
dashing start
```

Check out http://shopify.github.com/dashing for more information.

Configuration
=============
Copy config_default.yml to config.yml inside conf directory. Customize it to your needs.

```
// You can set ip and port of cgminer api (dont forget to run cgminer with --api-listen)
cgminer:
  host: 127.0.0.1
  port: 4028

//customize gpu params widget content
gpu:
  show_clocks: true
  fields:
    - 'Enabled'
    - 'Status'
    - 'Fan Speed'
    - 'GPU Activity'
    - 'Accepted'
    - 'Rejected'
    - 'Hardware Errors'

//customize market widget
market:
  enabled: true
  show_btce: true
  show_bitcurex: true
  show_ltc_to_pln: true

//pool links, key is the widget name, value is the api url with api key
//you can add more pools if you wish
pools:
  wemineltc: 'https://www.wemineltc.com/api?api_key=YOUR_API_KEY_HERE'
  givemecoins: 'https://give-me-coins.com/pool/api-ltc?api_key=YOUR_API_KEY_HERE'
```

Widgets
-------
You can customize layout od your dashboard (or even create more dashboards) by editing files inside "dashboards" directory. 

Actually cgdash provides data for the following widget types:
```
	//Temperature meter - gpu[N]_temp, where N is gpu number
    <li data-row="1" data-col="1" data-sizex="2" data-sizey="2">
      <div data-id="gpu0_temp" data-view="Meter" data-title="GPU-0 Temp" data-min="0" data-max="100"></div>
    </li>
    
    //gpu params - more detailed view of gpu, data-id is built by the same pattern: gpu[N]_params
    <li data-row="1" data-col="3" data-sizex="2" data-sizey="2">
      <div data-id="gpu0_params" data-view="List" data-title="GPU-0 params"></div>
    </li>
    <li data-row="3" data-col="3" data-sizex="2" data-sizey="2">
      <div data-id="gpu1_params" data-view="List" data-title="GPU-1 params"></div>
    </li>

	//Big view of current hashrate 
    <li data-row="1" data-col="5" data-sizex="2" data-sizey="2">
      <div data-id="gpu0_mhash" data-view="Number" data-title="GPU-0 MH/s"></div>
    </li>
    
	//market data    
    <li data-row="1" data-col="8" data-sizex="2" data-sizey="2">
      <div data-id="market" data-view="List" data-title="Market"></div>
    </li>
    
    //mining pool stats, data-id = pool_ + pool name from config file
    <li data-row="3" data-col="8" data-sizex="2" data-sizey="1">
      <div data-id="pool_wemineltc" data-view="Pool" data-title="WeMineLTC"></div>
    </li>
    <li data-row="3" data-col="8" data-sizex="2" data-sizey="1">
      <div data-id="pool_givemecoins" data-view="Pool" data-title="GiveMeCoins"></div>
    </li>
```
More information about dashboards can be found here: http://shopify.github.io/dashing/#overview


Tips welcome
============

Litecon: Lb6DQ5QaqbVDF4pXMAhiMPsVXyoFucMvKF
