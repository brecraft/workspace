#This script is used to connect to an API and create a data frame from the response
#Developed by Brenna Craft

library(httr,jsonlite,lubridate)

# API Password: e6a6326f-32e9-490c-a550-0fce0fe89d55

#Define URL and Perform GET
url  <- "https://holidayapi.com"
path <- "/v1/holidays?key=e6a6326f-32e9-490c-a550-0fce0fe89d55&country=US&year=2017&month=04"
raw.result <- GET(url = url, path = path)

#translate content into text
this.raw.content <- rawToChar(raw.result$content)

#parse the json
this.content <- fromJSON(this.raw.content)

#convert to dataframe
this.content.df <- do.call("rbind", this.content)

#Remove the first row which includes the status from the rest call
this.content.df <- this.content.df[-1,]


