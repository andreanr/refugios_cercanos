require(sp)
require(rgdal)
require(geosphere)
require(ggmap)

getGeoDetails <-function(address){  
  # Function that given a string address connects to google API
  # to find the geographical coordinates of the addres.
  
  # params adress: string
  # Returns a data frame with the coordinates, and the accuracy level
  
  # Paste the country 
  address = paste0(address, " Mexico")
  # geocode to google server
  geo_reply = geocode(address, output='all')
  # Create a data frame asnwer with the columns we want
  answer <- data.frame(lat=NA, long=NA, accuracy=NA)
  
  #else, extract what we need from the Google server reply into a dataframe:
  answer$lat <- geo_reply$results[[1]]$geometry$location$lat
  answer$long <- geo_reply$results[[1]]$geometry$location$lng   
  if (length(geo_reply$results[[1]]$types) > 0){
    answer$accuracy <- geo_reply$results[[1]]$types[[1]]
  }
  return(answer)
}


generate_closest_shelters <- function(shelters,lat,long,fun_distance,k_closest){
  # function that given a data frame of shelters and a new geographical coordinate
  # finds the k_closest shelters using the fun_distance.
  
  # Params:
  # shelters: dataframe of shelters that have x,y
  # lat, long: decimal coordinates of the point from where to calculate the distances
  # fun_distance: metric to use
  # k_closest: integer, number of closest shelters 
  
  # Returns:
  # df_display: dataframe with the k_closest shelters and their info
  shelters['distancia(m)'] = distm(shelters[,c('longitud_decimal','latitud_decimal')],
                                   c(long,lat),fun=fun_distance)
  df_display = shelters[order(shelters[,c('distancia(m)')])[1:k_closest],]

  return(df_display)
}