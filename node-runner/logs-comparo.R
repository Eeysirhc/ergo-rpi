
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
df %>% 
  group_by(sync_date, hour) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(
  # start header sync at 0 hour
    hour_standardized = row_number()-1) %>% 
  ungroup() %>% 
  mutate(n_cumsum = cumsum(n)) %>% 
  mutate(id = "4.0.27-swap") -> c

df_final <- bind_rows(a, b, c)

# plot graph
df_final %>% 
  mutate(n_cumsum = n_cumsum) %>% 
  ggplot(aes(hour_standardized, n_cumsum, color = id)) +
  geom_line() +
  geom_point() + 
  geom_hline(yintercept = 815000, lty = 2) + 
  scale_y_continuous(labels = comma_format()) +
  scale_color_brewer(palette = 'Set1') + 
  labs(x = "Node Sync Hour",
       y = NULL,
       color = NULL,
       title = "Ergo: 4.0.37 release comparison") +
  theme_bw(base_size = 15) +
  theme(legend.position = 'top')
