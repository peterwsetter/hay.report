# Download data, process, and save as rda

library(googlesheets)
library(dplyr)

gs_auth(token = '~/gs_token.rds')

gs <- gs_title('Plains Hay Report Data')

gs_read(gs) %>% 
  mutate(report_year = lubridate::year(report_date),
         report_week = lubridate::week(report_date),
         state = factor(state,
                        levels = rev(c('Montana', 'Wyoming', 'South Dakota',
                                   'Colorado', 'Nebraska', 'Kansas',
                                   'New Mexico', 'Oklahoma', 'Texas')),
                        ordered = TRUE),
         quality_ordered = factor(quality,
                                  levels = c('Utility', 'Fair', 'Fair/Good',
                                             'Good', 'Good/Premium', 
                                             'Premium', 'Premium/Supreme',
                                             'Supreme'),
                                  ordered = TRUE)
         ) %>% 
  rowwise() %>% 
  mutate(price_avg = mean(c(price_high, price_low), na.rm = TRUE)) %>% 
  ungroup() ->
  report_data

save(report_data, file = '../data/report_data.rds')
