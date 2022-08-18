## Intro to ggmap
## UNH R users group, 18 Aug 2022


# packages ----------------------------------------------------------------

require("ggmap")
require("devtools")
devtools::install_github('oswaldosantos/ggsn')

# https://mapsplatform.google.com/ -- get API key, now needed for ggmap
register_google(key ="")


# specify map location ----------------------------------------------------

# "box" latitude and longitude of location
# uses lower left lon, lower left lat, upper right lon, upper right lat
myLocation <- c(left = -68.320236,bottom = 44.268038,
                right = -68.167071,top = 44.408826)


# create map --------------------------------------------------------------

# two main map types you will be using
myMap1 <- get_stamenmap(bbox = myLocation, 
                        maptype="terrain-background", zoom = 13, scale = "auto")
ggmap(myMap1)

myMap2 <- get_stamenmap(bbox = myLocation, 
                        maptype="toner-lite", zoom = 13, scale = "auto")
ggmap(myMap2)

# just for fun ...
myMap3 <- get_stamenmap(bbox = myLocation, 
                        maptype="watercolor", zoom = 13, scale = "auto")
ggmap(myMap3)


# fix up axes -------------------------------------------------------------

myMap1.2 <- ggmap(myMap1) + 
  labs(x = 'Longitude', y = 'Latitude')+ # changes x and y axis titles
  ggtitle("Acadia National Park")+ # changes map title
  theme(axis.text = element_text(size = 8, color = "black"), # axis size and color 
        axis.title=element_text(size = 10), # axis title size 
        axis.ticks = element_line (colour = "black", size = 1), # axis ticks size and color  
        axis.line = element_line(color = "black", size = 1), # axis lines size and color
        plot.title = element_text(hjust=0.5)) # adjusts location of map title

myMap1.2


# add scale bar to map ----------------------------------------------------

myMap1.3 <- myMap1.2 +
  scalebar(x.min = -68.24, x.max = -68.18, # where in x-axis range it will be
           y.min = 44.28, y.max = 44.32, dist_unit = "km", # where in y axis range 
           # it will be, also specifies units
           dist = 2, transform = TRUE, model = "WGS84", height = 0.05, # what units
           # you want the scale bar in, height, etc.
           st.dist = 0.1, st.size = 3, border.size = 0.3) 
myMap1.3


# add site annotations ----------------------------------------------------
# you can use the geom_point and annotate functions to do this

myMap1.4 <- myMap1.3 +
  # labeling sand beach
  geom_point(aes(x = -68.181973, y = 44.329205), data = NULL, 
           alpha = 0.5, color = "black", size = 2, pch= 18)+ # specify point location,
            # color of point, size, shape
  annotate('text', x = -68.181973, y = 44.325, label = 'SB', 
           colour = I("black"), size = 2) + # label point, color, size of label
  # labeling cadillac mountain
  geom_point(aes(x = -68.225104, y = 44.352582), data = NULL, 
             alpha = 0.5, color = "black", size = 2, pch= 18)+ # specify point location,
  # color of point, size, shape
  annotate('text', x = -68.225, y = 44.3485, label = 'CM', 
           colour = I("black"), size = 2) # label point, color, size of label

myMap1.4


# adding an inset to the map ----------------------------------------------

states <- map_data("state")
maine <- subset(states, region %in% c('maine'))

maine2<-ggplot(data = maine) + 
  geom_polygon(aes(x = long, y = lat, group = group), fill = "white", color = "black") + 
  geom_point(aes(x =-68.2733, y =  44.3386), color = 'red', size = 3, pch = 18)+
  coord_fixed(1.5)+
  theme_void() +
  xlab("") + ylab("")

maine2

myMap1.4+
  inset(ggplotGrob(maine2), xmin = -68.32, ymin = 44.36, xmax = -68.28, ymax = 44.41)
# more useful in different situations

# add data to the map -----------------------------------------------------

setwd("path") # insert path to directory here
sites <- read.csv("acadia_sites.csv", header = TRUE)

# make data based on color
myMap1.3 + 
  geom_point(data=sites, aes(x=Long, y=Lat, color=Visitors), size=3)+
  scale_colour_gradient(low = "grey50", high="grey0")

# OR

# make data based on size
myMap1.3 + 
  geom_point(data=sites, aes(x=Long, y=Lat, size=Visitors))
