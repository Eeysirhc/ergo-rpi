# ergo-rpi

This repo is primarily intended for developers running headless Raspberry Pi's (no desktop environment) who want to use the various Ergo services. With that said, individuals on the desktop version can still follow this guide by executing the same commands in their Pi terminal window.

## [Ergo Node](https://github.com/ergoplatform/ergo)

The node is a critical piece of infrastructure to interact, host, and synchronize a copy of the entire Ergo blockchain. There is no financial incentive to run a node but doing so helps increase the security of the network.

> Note: as of this writing, release 4.0.27 has demonstrated itself to have the fastest sync time for the Pi. You can swap over to the latest version after the network sync is complete.

### Minimum requirements

* Raspberry Pi 4 with 4GB RAM 
* Installed Raspberry Pi OS (64-bit) with the [official imager](https://www.raspberrypi.com/software/)

### [WIP] Node sync table
| Release | MicroSD size | SWAP increase | SWAP default | 
| --- | --- | --- | --- | 
| 4.0.27 | 32gb | 4.5 days | - | 
| 4.0.27 | 256gb | 1.5 days | - | 
| 4.0.35 | 256gb | - | in progress | 

### Prepare installation
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install default-jdk -y
```

### Increase SWAP size

The steps below optimizes your Pi's hardware and extends its operational capabilities. 

```bash
sudo dphys-swapfile swapoff
sudo nano /etc/dphys-swapfile

# Edit the default value of 100
CONF_SWAPSIZE=4096
# Save file with "CTRL + X" then hit "Y" and "ENTER" to confirm

sudo dphys-swapfile setup
sudo dphys-swapfile swapon
sudo reboot now
```

### Download JAR

Find the latest release in the [Ergo GitHub](https://github.com/ergoplatform/ergo/releases).

```bash
wget https://github.com/ergoplatform/ergo/releases/download/v<VERSION>/ergo-<VERSION>.jar
````

### Compute API key hash

Replace `hello` with your own secret key.

```bash
curl -X POST "http://213.239.193.208:9053/utils/hash/blake2b" \
-H "accept: application/json" \
-H "Content-Type: application/json" \
-d "\"hello\""
```

### Add config file

The following command opens up the text editor.

```bash
sudo nano ergo.conf 
```

Then copy & paste the contents below while also replacing the `apiKeyHash` with the response from the previous step.

```bash
ergo {
  node {
    mining = false
  }
}

scorex {
 restApi {
    # Hex-encoded Blake2b256 hash of an API key. 
    # Should be 64-chars long Base16 string.
    # below is the hash of the string 'hello'
    # replace with your actual hash 
    apiKeyHash = "324dcf027dd4a30a932c441f365a25e86b173defa4b8e58948253471b81b72cf"
  }
}
```

### Launch node (with 2gb heap size)
```bash
java -jar -Xmx2g ergo-<NODE>.jar --mainnet -c ergo.conf
```

### Web UI access

Below is the default address but if you're running headless then replace the `127.0.0.1` portion with your `<rpi-ip-address>`.

```bash
http://127.0.0.1:9053/panel
```

## Coming soon

- [ ] [Ergo Wallet App (desktop)](https://github.com/ergoplatform/ergo-wallet-app)
- [ ] [Ergo Mixer](https://github.com/ergoMixer/ergoMixBack)
- [ ] [ErgoDEX Off-Chain Bots](https://github.com/ergolabs/ergo-dex-backend)
- [ ] [Ergo Off-Chain Execution](https://github.com/ergo-pad/ergo-offchain-execution)
- [ ] [ErgoPad Off-Chain](https://github.com/ergo-pad/ergopad-offchain)
- [ ] [Paideia Off-Chain](https://github.com/ergo-pad/paideia-offchain)

## systemd

Ideally, your Ergo services run in the background and automatically reboots in the event of an outage. The steps below is one example on how to setup this process for the node on your Raspberry Pi.

### Create service

```bash
sudo nano /etc/systemd/system/ergonode.service
```

### Edit service file

```bash
[Unit]
Description=Ergo Node
After=multi-user.target

[Service]
WorkingDirectory=/path/to/ergo-node
User=pi
ExecStart=/usr/bin/java -jar -Xmx2g ergo-<VERSION>.jar --mainnet -c ergo.conf
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

### Grant permissions

```bash
sudo chmod 644 /etc/systemd/system/ergonode.service 
```

### Update systemd

```bash
sudo systemctl daemon-reload
sudo systemctl enable ergonode.service
sudo systemctl start ergonode.service
```
