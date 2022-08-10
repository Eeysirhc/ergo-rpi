# Appendix

The contents on this page will primarily house notes, backlog tasks, deprecated items, etc.

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




