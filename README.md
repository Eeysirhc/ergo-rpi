# ErgoPi

To do: add repo objective & description

## [Ergo Node](https://github.com/ergoplatform/ergo)

The node is a critical piece of infrastructure to interact, host, and synchronize a copy of the entire Ergo blockchain. There is no financial incentive to run a node but doing so helps increase the security of the network.

> Note: as of this writing, release 4.0.27 has demonstrated itself to have the fastest sync time for the Pi. You can swap over to the latest version after the network sync is complete.

### Minimum requirements

* Raspberry Pi 4 with 4GB RAM (or more)
* 32GB MicroSD: total sync time of 4.5 days
* 256GB MicroSD: total sync time of 1.5 days

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

Find the latest release in their [GitHub](https://github.com/ergoplatform/ergo/releases).

```bash
mkdir ergo
cd ergo
wget https://github.com/ergoplatform/ergo/releases/download/v<node-version>/ergo-<node-version>.jar
````

### Compute API key hash

Replace `hello` with your own secret key.

```bash
curl -X POST "http://213.239.193.208:9053/utils/hash/blake2b" \
-H "accept: application/json" \
-H "Content-Type: application/json" \
-d "\"hello\""
```

### Add Config File

The following command opens up your Pi text editor.

```bash
sudo nano ergo.conf 
```

Then paste the contents below while remembering to repalce the `apiKeyHash` with the response from the previous step.

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

### Launch Node (with 2G heap size)
```bash
java -Xmx2g -jar ergo-<node-version>.jar --mainnet -c ergo.conf
```

## Coming soon

- [ ] [Ergo Mixer](https://github.com/ergoMixer/ergoMixBack)
- [ ] [ErgoDEX Off-Chain Service](https://github.com/ergolabs/ergo-dex-backend)
- [ ] [Ergo Off-Chain Execution](https://github.com/ergo-pad/ergo-offchain-execution)
- [ ] [ErgoPAD Off-Chain Execution](https://github.com/ergo-pad/ergopad-offchain)
- [ ] [Paideia Off-Chain Execution](https://github.com/ergo-pad/paideia-offchain)

## systemd

Ideally, your Ergo node runs in the background and automatically restarts itself in the event of an outage. The steps below detail how to setup this process for your Raspberry Pi.

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
ExecStart=/usr/bin/java -jar -Xmx2g /path/to/ergo-node/ergo-<node-version>.jar --mainnet -c /path/to/ergo-node/ergo.conf
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



