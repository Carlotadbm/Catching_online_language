###Carlota de Benito Moreno
###Catching language data Summer School
###June 23rd 2021
###Access to Twitter Stream API with streamR

##install libraries (must be done only once)
install.packages("streamR")
install.packages("ROAuth")
install.packages("tidyverse")
##load library (must be done in every new session of RStudio)
library(streamR)
library(ROAuth)
library(tidyverse)


##Authenticate in Twitter
#You will need to put your data from your own Twitter API
#You can create one here: https://developer.twitter.com/en/docs/getting-started
my_oauth <- OAuthFactory$new(consumerKey="your_consumer_key",
                             consumerSecret="your_consumer_secret", 
                             requestURL="https://api.twitter.com/oauth/request_token",
                             accessURL="https://api.twitter.com/oauth/access_token", 
                             authURL="https://api.twitter.com/oauth/authorize")
#After running the following line of code you will be directed to a Twitter website:
#You will be asked to authorize the API and, afterwards, you will get a PIN code
#which you will have to copy in the console and run it (by pressing enter)
my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
#save your authentication for every search
save(my_oauth, file = "my_oauth.Rdata")
#load you authentication
load("my_oauth.Rdata")

#Attention: this library generates .json files that are saved to your computer
#You can set the directory (folder) where you want to save these files 
#by clicking in "Files" in the right bottom window, navigating to the desired folder
#and once you're there, clicking in More > Set as working directory


##Search by coordinate and number of tweets
#Establish coordinates: it's a coordinate box
#2 latitudes and 2 longitudes, in a rectangle with the order 
#left (Eastern longitude), bottom (Southern latitude), right (Western longitude), up (Northern latitude)
#Example: 
#coordinate box containing (part of) USA 
coord <- "-124.65, 22.80, -66.64, 49.53"
#Create a file called usa.json with the next 10 tweets 
#geolocated within the coordinate box set in coord
filterStream(file.name = "usa.json", 
             locations = coord, 
             tweets = 10, 
             oauth = my_oauth)
?filterStream
##Search by language during a period of time in a given area
#Example:
#Create a file called english.json with the tweets generated in English
#the next 60 seconds
filterStream(file.name = "english.json", 
             language = "en",
             locations = coord,
             timeout = 60,
             oauth = my_oauth)

##Search by string and number of tweets
#Example:
#Create a file called literally.json with the next 10 tweets with the word "literally"
filterStream(file.name = "literally.json", 
             track = "literally",
             tweets = 10, 
             oauth = my_oauth)

##Parsing .json files and converting them into .csv files
#.json files are structured files but hard to read
#Example:
#parse english.json file and save it as an R object (dataframe) called english
english <- parseTweets("english.json")
#write into a .csv file (delimited by tabs) called english
write_delim(english, "english.csv", delim = "\t")


###Create a map with the tweets obtained in our "english" search
##install libraries (must be done only once)
install.packages("mapproj")
##load library (must be done in every new session of RStudio)
library(mapproj) 

#read the csv english.csv
english <- read_delim("english.csv", delim = "\t")

#load political blank map
usa <- map_data("usa") #of the USA

#Create map
ggplot(usa, aes(x = long, y = lat)) + #input to ggplot: the blank map loaded and the fields with longitude (long) and latitude (lat)
  geom_map(map=usa, aes(map_id=region), fill="white", colour="black") + #add shapes of the countries (regions) with geom_map
  geom_point(data = english, aes(x = place_lon, y = place_lat), #add points for the data in english. place_lon and place_lat are the fields with coordinates information in english
             alpha = 0.5, position=position_jitter(h=0.1, w=0.1)) + #alpha sets transparency level of the points, position_jitter makes them move to avoid overlapping
  coord_map() + #set Mercator projection
  labs(title = "Tweets in English") + #add title
  theme_bw() + #set background to white
  theme(panel.grid = element_blank(), #set other format parameters (remove panel grid)
        panel.border = element_blank(), #remover panel border
        axis.title = element_blank(), #remove axis title
        axis.text = element_blank(), #remove axis text
        axis.ticks = element_blank()) #remove axis ticks

#Save last plot as a png file (english_TW.png)
ggsave("english_TW.png", scale = 1.5) 

