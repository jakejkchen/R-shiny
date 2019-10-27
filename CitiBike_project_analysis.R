citibike_trip = read.csv('./Data/201709-citibike-tripdata.csv')
head(citibike_trip)
library(leaflet)
citibike_trip$tripduration = citibike_trip$tripduration/60

subway_station = read.csv('./Data/DOITT_SUBWAY_STATION_01_13SEPT2010.csv')
head(subway_station)

citibike_trip_10 = citibike_trip[1:10,]
leaflet(citibike_trip_10) %>% addTiles() %>% addCircleMarkers(lng = ~start.station.longitude,
                                                     lat= ~start.station.latitude,
                                                     radius=2)
library(dplyr)
library(tidyr)


library(stringr)
gsub("POINT \\((.*)\\)", "\\1", "POINT (-73.99106999861966 40.73005400028978)")

subway_station$the_geom = lapply(subway_station$the_geom, 
                                 function(x) gsub("POINT \\((.*)\\)", "\\1", x))


head(subway_station)
subway_station = subway_station %>% separate(the_geom, c('lng', 'lat'), ' ')
head(subway_station)
subway_station$lng = as.numeric(subway_station$lng)
subway_station$lat = as.numeric(subway_station$lat)
leaflet(subway_station) %>% addTiles() %>% addCircleMarkers(lng = ~lng,
                                                              lat= ~lat,
                                                              radius=2)

citibike = tbl_df(citibike_trip)
class(citibike)

#start station analysis
by_start_station = group_by(citibike, start.station.name, 
                            start.station.longitude, start.station.latitude)
start_station_count = summarise(by_start_station, count = n())
class(start_station_count)
leaflet(start_station_count) %>% addTiles() %>% 
    addCircleMarkers(lng = ~start.station.longitude,
                    lat= ~start.station.latitude,
                    radius=2) %>% setView(lng = -74.006, lat = 40.7128, zoom = 11)
top_20_start_station = arrange(start_station_count, desc(count))[1:20,]

#end station analysis
by_end_station = group_by(citibike, end.station.name, 
                          end.station.longitude, end.station.latitude)
end_station_count = summarise(by_end_station, count= n())
leaflet(end_station_count) %>% addTiles() %>% 
    addCircleMarkers(lng = ~end.station.longitude,
                     lat= ~end.station.latitude,
                     radius=2, color= 'red') %>% setView(lng = -74.006, lat = 40.7128, zoom = 11)

top_20_end_station= arrange(end_station_count, desc(count))[1:20,]
library(ggplot2)
#average trip durations
g = ggplot(data=citibike, aes(x=tripduration))
g + geom_histogram(color='white')+xlim(c(0,100))

top20_start= ggplot(data=citibike[citibike$start.station.name %in% top_20_start_station$start.station.name,],
                    aes(x=reorder(start.station.name, -tripduration), y=tripduration))

top20_start+geom_bar()+theme(axis.text.x = element_text(angle=45, hjust=1))
top20_start+stat_summary(fun.y='mean', geom='bar')+theme(axis.text.x = element_text(angle=45, hjust=1))

top20_end= ggplot(data=citibike[citibike$end.station.name %in% top_20_end_station$end.station.name,],
                    aes(x=reorder(end.station.name, -tripduration), y=tripduration))
top20_end+stat_summary(fun.y='mean', geom='bar')+theme(axis.text.x = element_text(angle=45, hjust=1))

write.csv(citibike_trip, './Data/citibike_trip.csv')
subway_station$URL = NULL
subway_station$NOTES = NULL
write.csv(subway_station, './Data/subway_station.csv')