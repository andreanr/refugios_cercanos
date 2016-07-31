require(XLConnect)

#---------------------------------------
# Read Excel Spread Sheet (.xlsx / .xls)
#---------------------------------------
wb = loadWorkbook("refugios_nayarit.xlsx")
sheet_names = getSheets(wb)
lst = readWorksheet(wb, sheet = getSheets(wb), startRow=7, header = FALSE)
shelters_data = do.call(rbind,lst)

#------------------
# Name the Columns
#------------------
column_names = c('numero','refugio','municipio','direccion','uso_inmueble','servicios',
                 'capacidad','latitud','longitud','altitud','responsable','telefono')
colnames(shelters_data) = column_names
# Delete incomplete rows
shelters_data = shelters_data[complete.cases(shelters_data),]

#-------------------
# Clean coordinates
#-------------------
degree_to_decimal <-function(x){
  # Function that homologates the pattern for degree coordinates 
  # and transforms them into decimal coordinates
  
  # clean coordinate string
  pattern = c("^(\\d{2,3})(\\D+\ ?)(\\d{2})(\\D\ ?)(\\d{2})(\\D)(\\d{2})(\\D?)")
  replace = c("\\1\\-\\3\\-\\5\\.\\7\\-")
  clean_coord = gsub(pattern,replace,x,perl=TRUE)
  # transform to decimal
  decimal_coord = as.numeric(strsplit(clean_coord,'-')[[1]][1]) + 
                  as.numeric((strsplit(clean_coord,'-')[[1]][2]))/60 + 
                  as.numeric((strsplit(clean_coord,'-')[[1]][3]))/3600
  return(decimal_coord)
}

# Apply to latitud and longitud
shelters_data$latitud_decimal = sapply(shelters_data$latitud, function(x) degree_to_decimal(x))
shelters_data$longitud_decimal = sapply(shelters_data$longitud, function(x) -degree_to_decimal(x))


#---------------------------------------------------
# Filter to feasible ranges for latitud and longitud 
#---------------------------------------------------
shelters_to_use = shelters_data[shelters_data$latitud_decimal <= 90 & 
                                  abs(shelters_data$longitud_decimal) <= 180 & 
                                  complete.cases(shelters_data[c('longitud_decimal','latitud_decimal')]),]


# Write to csv
write.csv(shelters_to_use,file='refugios_nayarit_clean.csv')
