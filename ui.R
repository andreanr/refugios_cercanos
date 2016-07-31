library(shiny)

# Define UI for application that finds the n closest shelters given an address
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Encuentra los Refugios de Nayarit más cercanos a tu ubicación"),
  
  # Sidebar
  sidebarLayout(
    sidebarPanel(
      # Address box
      textInput("direccion","Ingrese su direccion \n
                (calle y numero, colonia, municipio, estado):",
                value='Tepic, Nayarit'),
      # Number of shelters
       sliderInput("n_refugios",
                   "Número de refugios cercanos:",
                   min = 1,
                   max = 10,
                   value = 3),
      # zooming in map
       sliderInput("zoom","zoom mapa:", min=10, max=20, value=15, ticks = FALSE)
    ),
    
    # Show the map and the table
    mainPanel(
       plotOutput("distPlot"),
       div(tableOutput("distTable"), style = "font-size:80%")
    )
  )
))
