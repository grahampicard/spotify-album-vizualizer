#### Graph Noodling ####
library(dplyr)
library(tidyr)
library(ggplot2)
source("global.R")
setwd("~/../Dropbox/github/spotify-artist-app")

inputvar <- c("Duration", "Energy")
labels <- c("Minutes", "Energy")
setNames(labels, inputvar)

ggplot(data = tg) + 
  aes(track, Duration) + 
  geom_bar(stat = 'identity') + 
  coord_flip() +
  theme(panel.background = element_blank(),
  plot.background = element_blank(),
  legend.title = element_blank(),
  # legend.text = element_text(color="#555555", size = 12),
  legend.background = element_blank(),
  legend.key = element_blank(),
  axis.title.x = element_blank(),
  axis.title.y = element_blank(),
  axis.ticks.x = element_blank(),              
  panel.grid.major.x = element_blank(),
  panel.grid.minor.x = element_blank(),
  panel.grid.minor.y = element_blank()
  )  	    



