# [Ergo Node](https://github.com/ergoplatform/ergo)

The node is a critical piece of infrastructure to interact, host, and synchronize a copy of the entire Ergo blockchain. There is no financial incentive to run a node but doing so helps increase the security of the network.

> Node [sync duration tracker](https://github.com/Eeysirhc/ergo-rpi-node-logs/tree/main/releases) for each release.

## Minimum requirements

* Raspberry Pi 4 with 4GB RAM 
* Raspberry Pi OS (64-bit) with the [official imager](https://www.raspberrypi.com/software/)

## Setup guide 

### Prepare installation
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install default-jdk -y
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

The default address is `127.0.0.1` but if you're running headless then you can bring up the node UI on a separate computer.

```bash
http://<RPI-IP-ADDRESS>:9053/panel
```

## Appendix

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


