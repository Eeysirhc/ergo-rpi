
# load library
library(tidyverse)
library(lubridate)
library(scales)
library(data.table)

# load data
files <- list.files(pattern = ".txt")

df_raw <- map(files, read.table, sep='', header = FALSE) %>%
  set_names(files) %>%
  bind_rows(.id = 'filename') %>%
  as_tibble() %>%
  rename(logfile = V1,
         time = V2,
         height = V3)

# format data
df <- df_raw %>%
  mutate(
    # extract date from logs filepath then text cleanup
    sync_date = str_extract(logfile, "2022-.*-*\\."),
    sync_date = gsub("\\.", "", sync_date),
    sync_date = ymd(sync_date),
    # if empty mark as today's date
    sync_date = replace_na(sync_date, Sys.Date()),
    # extract hour
    hour = hour(as.ITime(time)))

# process data
df_final <- df %>%
  group_by(filename, sync_date, hour) %>%
  arrange(sync_date, time) %>%
  count() %>%
  ungroup() %>%
  group_by(filename) %>%
  mutate(hour_standardized = row_number() - 1) %>%
  ungroup() %>%
  group_by(filename) %>%
  mutate(block_height = cumsum(n)) %>%
  ungroup()

# plot graph
p <- df_final %>%
  ggplot(aes(hour_standardized, block_height, color = filename)) +
  geom_line(size = 1) +
  geom_point(size = 3) +
  geom_hline(yintercept = 813000, lty = 2) +
  scale_y_continuous(labels = comma_format()) +
  scale_color_brewer(palette = 'Set1') +
  labs(x = "Node Sync Hour",
       y = NULL,
       color = NULL,
       title = "ergo-rpi: 4.0.37 release comparison",
       subtitle = "Dotted line with block height of 813000") +
  theme_bw(base_size = 15) +
  theme(legend.position = 'top')

# save graph
ggsave("img/results-4.0.37.png",
       plot = p,
       width = 18,
       height = 12,
       dpi = 300)
