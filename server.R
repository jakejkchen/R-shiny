#library(shinydashboard)
shinyServer(function(input, output, session) {
    start_station = reactive({
        citibike_start = citibike %>% group_by(start.station.name, 
                                         start.station.longitude, start.station.latitude) %>%
            summarise(count=n()) %>% arrange(desc(count))
        citibike_start=citibike_start[1:input$start_num, ]
        citibike_start
    })
    
    end_station = reactive({
        citibike_end = citibike %>% group_by(end.station.name, 
                                         end.station.longitude, end.station.latitude) %>%
            summarise(count=n()) %>% arrange(desc(count))
        citibike_end=citibike_end[1:input$end_num, ]
        citibike_end
    })

    
    output$startmap = renderLeaflet({
        leaflet(start_station()) %>% addProviderTiles('Esri.NatGeoWorldMap') %>% 
            addMarkers(lng = ~start.station.longitude,
                        lat= ~start.station.latitude,
                       popup = ~htmlEscape(start.station.name)) %>% setView(lng = -74.006, lat = 40.7128, zoom = 11) %>% 
            addCircleMarkers(data=subway, lng=~lng, lat=~lat, radius=3, color='red')
    })
    
    output$top_start = renderPlot({
        ggplot(data=start_station(), aes(x=reorder(start.station.name, -count), y=count, fill=start.station.name))+geom_col()+
            theme(axis.text.x = element_text(angle=45, hjust=1))+
            theme(axis.text=element_text(size=10))
    })
    output$avg_start = renderPlot({
        ggplot(data=citibike[citibike$start.station.name %in% start_station()$start.station.name,],
               aes(x=reorder(start.station.name, -tripduration), y=tripduration, fill=start.station.name))+
            stat_summary(fun.y='mean', geom='bar')+theme(axis.text.x = element_text(angle=45, hjust=1)) +
            theme(axis.text=element_text(size=15))
    })
    
    output$endmap = renderLeaflet({
        leaflet(end_station()) %>% addProviderTiles('Esri.NatGeoWorldMap') %>% 
            addMarkers(lng = ~end.station.longitude,
                             lat= ~end.station.latitude
                             ) %>% setView(lng = -74.006, lat = 40.7128, zoom = 11) %>% 
            addCircleMarkers(data=subway, lng=~lng, lat=~lat, radius=3, color='red')
    })
    
    output$top_end = renderPlot({
        ggplot(data=end_station(), aes(x=reorder(end.station.name, -count), y=count, fill=end.station.name))+geom_col()+
            theme(axis.text.x = element_text(angle=45, hjust=1))+
            theme(axis.text=element_text(size=10))
    })
    output$avg_end = renderPlot({
        ggplot(data=citibike[citibike$end.station.name %in% end_station()$end.station.name,],
               aes(x=reorder(end.station.name, -tripduration), y=tripduration, fill=end.station.name))+
            stat_summary(fun.y='mean', geom='bar')+theme(axis.text.x = element_text(angle=45, hjust=1))+
            theme(axis.text=element_text(size=10))
            
    })
    
    
    
    output$avg_time = renderPlot({
        ggplot(data=citibike, aes(x=tripduration))+
            geom_histogram(color='white')+xlim(c(0,75))})
    output$avg_age = renderPlot({ggplot(data=citibike, aes(x=Age))+
            geom_histogram(color='white')+xlim(c(0,100))})
    output$gender_prop = renderPlot({ggplot(citibike) + geom_bar(aes(gender_var, 
             y = (..count..)/sum(..count..), fill=gender_var)) + ylab("Proportion")+ xlab('Gender')})
    output$weekday_usage = renderPlot({
        ggplot(citibike) + geom_bar(aes(x=weekday, fill=weekday)) + theme_bw() + ylab("Count")
    })
    
    output$hour_usage = renderPlot({
        ggplot(citibike) + geom_bar(aes(x=hour, fill=hour)) + theme_bw() + ylab("Count")
        
    })
    
    })
