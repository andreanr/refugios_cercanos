library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # import script
  source('closest_shelters.R')
  
  # Load clean data
  shelters = read.csv('refugios_nayarit_clean.csv')
  
  # Receive inputs direccion and number of shelters
  direccion = reactive({input$direccion})
  n_refugios = reactive({input$n_refugios})
  
  # geocode the input address
  geocoder = reactive({getGeoDetails(direccion())})
  
  # recieve dataframe with the n closest shelters and their info
  closest_shelters <- reactive ({generate_closest_shelters(shelters,
                                                           geocoder()$lat,
                                                           geocoder()$lon,
                                                           distHaversine,
                                               n_refugios())})
  
  # display table
  output$distTable = renderTable({
     closest_shelters()[c('refugio','municipio','direccion','servicios','capacidad',
                          'responsable','telefono','distancia(m)')]
  })
  
  # display map
  output$distPlot = renderPlot({
    # Generate bounding box
    lat_bottom <- reactive({min(closest_shelters()$latitud_decimal)})
    lat_top <- reactive({max(closest_shelters()$latitud_decimal)})
    long_left <- reactive({min(closest_shelters()$longitud_decimal)})
    long_right <- reactive({max(closest_shelters()$longitud_decimal)})
    
    # Get nayarit map zooming and using the bbox
    nayarit <- get_map(location =c(lon=mean(c(long_left(),long_right())),
                                   lat=mean(c(lat_top(),lat_bottom()))),
                       maptype='roadmap',source='google',zoom=input$zoom)
    
    # Plot the shelter points and the address 
    ggmap(nayarit) + geom_point(aes(x = longitud_decimal, y = latitud_decimal),
                                size = 5, data = closest_shelters(),
                                shape=17, color='darkcyan') +
      geom_text(aes(x = longitud_decimal, y = latitud_decimal,label=numero)
                ,data = closest_shelters(), vjust=1.8, color='darkcyan',size=4) +
      geom_point(aes(x= long, y = lat), data= geocoder(),
                 color='darkmagenta',size=5) + 
      annotate("text", label = "You are here", x = geocoder()$long,
               y = geocoder()$lat, size = 4, colour = "darkred", vjust=-1.2) +
      theme(axis.title.x=element_blank(),
            axis.text.x=element_blank(),
            axis.ticks.x=element_blank(),
            axis.title.y=element_blank(),
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank()) 
    
    
  })
  
})
