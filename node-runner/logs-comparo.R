
# load library
library(tidyverse)
library(lubridate)
library(scales)

# load data
df_raw <- read.table("processed.txt",
              header = FALSE)

# add headers
new_headers <- c("filename", "time", "height")
colnames(df_raw) <- new_headers

# format data
df <- df_raw %>% 
  as_tibble() %>% 
  mutate(
    # extract date from logs filepath then text cleanup
    sync_date = str_extract(filename, "2022-.*-*\\."),
    sync_date = gsub("\\.", "", sync_date),
    sync_date = ymd(sync_date),
    # if empty mark as today's date
    sync_date = replace_na(sync_date, Sys.Date())) 

# process data
df_processed <- df %>% 
  mutate(hour = hour(hms(time))) %>% 
  group_by(sync_date, hour) %>% 
  count() %>% 
  ungroup() %>% 
  mutate(
  # start header sync at 0 hour
    hour_standardized = row_number()-1) %>% 
  ungroup() %>% 
  mutate(n_cumsum = cumsum(n)) 


# plot graph
df_processed %>% 
  mutate(n_cumsum = n_cumsum) %>% 
  ggplot(aes(hour_standardized, n_cumsum)) +
  geom_line() +
  geom_hline(yintercept = 811522, lty = 2) + 
  scale_y_continuous(labels = comma_format()) 




