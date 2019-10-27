library(leaflet)
library(dplyr)
library(tidyr)
library(ggplot2)
library(shiny)
library(shinydashboard)
library(htmltools)
library(lubridate)

citibike_trip = read.csv('./Data/citibike_trip.csv')
subway = read.csv('./Data/subway_station.csv')

citibike = tbl_df(citibike_trip)

citibike$weekday = wday(citibike$starttime, label=TRUE)
citibike$hour    = as.factor(hour(citibike$starttime))

bike_icon = makeIcon('www/bike_icon.png', iconWidth = 30, iconHeight = 35)