# ergo-rpi

This repo is primarily intended for developers running headless Raspberry Pi's (no desktop environment) who want to use the various Ergo services. With that said, individuals on the desktop version can still follow this guide by executing the same commands in their Pi terminal window.

## Guides

* [Ergo Node](docs/ergo-node.md)

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

## Coming soon

* [Ergo Wallet App (desktop)](https://github.com/ergoplatform/ergo-wallet-app)
* [Ergo Mixer](https://github.com/ergoMixer/ergoMixBack)
* [ErgoDEX Off-Chain Bots](https://github.com/ergolabs/ergo-dex-backend)
* [Ergo Off-Chain Execution](https://github.com/ergo-pad/ergo-offchain-execution)
* [ErgoPad Off-Chain](https://github.com/ergo-pad/ergopad-offchain)
* [Paideia Off-Chain](https://github.com/ergo-pad/paideia-offchain)


