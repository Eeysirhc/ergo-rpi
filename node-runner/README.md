
## RPi node sync

Track and compare the different Ergo node release sync durations over time for the Raspberry Pi and its optimal configurations.

## Outcomes

*work in progress*

## DIY steps

### Retrieve & process log files

```bash
bash runner-logs.sh 
```

When prompted insert `node IP address` and `node logs directory`.

### Compute results

You'll need the [R](https://www.r-project.org/) statistical computing language and a few packages: `tidyverse`, `lubridate`, `scales`.

```r
Rscript logs-comparo.R 
```

### Appendix

#### Deprecated 

| Release | MicroSD | SWAP config | Crashes | Headers | Node | Wallet | Total | 
| --- | --- | --- | --- | --- | --- | --- | --- | 
| 4.0.35 | 256gb | yes | - | 2h | [in progress] | - | - | 
| 4.0.35 | 256gb | - | 2 | 2.25h | 46h | 13h | 2.6 days | 
| 4.0.27 | 256gb | yes | - | 1h | 30h | 5h | 1.5 days | 
| 4.0.27 | 32gb | yes | 4 | 3h | 90h | 15h | 4.5 days | 

