#library(shinydashboard)
dashboardPage(
    dashboardHeader(
        title = "Jun Kui Chen",
        titleWidth = 350
    ),
    dashboardSidebar(
        width = 350,
        sidebarMenu(
            menuItem("Top Start Station", tabName='start', icon = icon('globe')),
            menuItem('Top End Station', tabName='end', icon=icon('globe')),
            menuItem('Analysis', tabName='analysis', icon=icon('th'))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName='start',
                    fluidRow(
                        box(title = h3('Top CitiBike Start Stations'),
                            leafletOutput('startmap', height= 800)),
                        box(title='Filter your station',
                            sliderInput(inputId='start_num',
                                        label='Number of Top Start Stations',
                                        0, 50, 10)),
                        box(title='Top Start Stations', plotOutput('top_start')),
                        box(title='Average Trip Time From Start Stations (min)',
                            plotOutput('avg_start'))
                    )
            ),
            tabItem(tabName='end',
                    fluidRow(
                        box(title = h3('Top CitiBike End Stations'),
                            leafletOutput('endmap', height=800)),
                        box(title='Filter your station',
                            sliderInput(inputId='end_num',
                                        label='Number of Top End Stations',
                                        0, 50, 10)),
                        box(title='Top End Stations', plotOutput('top_end')),
                        box(title='Average Trip Time From End Stations (min)',
                            plotOutput('avg_end'))
                        
                    )
            ),
            tabItem(tabName = 'analysis',
                    fluidRow(
                        box(title=h3('Distribution of trip duration in minutes'),
                            plotOutput('avg_time')),
                        box(title=h3('Distribution of biker age'),
                            plotOutput('avg_age')),
                        box(title=h3('Proportion of each gender'),
                            plotOutput('gender_prop')),
                        box(title=h3('Bike usage in each weekday'),
                            plotOutput('weekday_usage')),
                        box(title=h3('Bike usage in each hour'),
                            plotOutput('hour_usage'))
            
        )
    )
)))