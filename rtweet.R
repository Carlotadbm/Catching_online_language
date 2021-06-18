###Carlota de Benito Moreno
###Catching language data Summer School
###June 23rd 2021
###Access to Twitter Search API with rtweet

##install library (must be done only once)
install.packages("rtweet")
install.packages("tidyverse")
##load library (must be done in every new session of RStudio)
library(rtweet)
library(tidyverse)


##Authenticate in Twitter
#You will need to put your data from your own Twitter API
#You can create one here: https://developer.twitter.com/en/docs/getting-started
token <- create_token(
  app = "name_of_user_created_Twitter_application",
  consumer_key = "your_consumer_key",
  consumer_secret = "your_consumer_secret",
  access_token = "your_access_token",
  access_secret = "your_access_secret")

##Search by word
#Example: look for 100 tweets (max) with the word "youthquake", with no retweets
#The result of the search will be saved as an object (a tibble) called youthquake
youthquake <- search_tweets(q = "youthquake", n = 100, include_rts = FALSE) #Funciona

#Example: look for 1000 tweets (max) with the sequence "because reasons", with no retweets
#Note the quotes!! Double quotes within single quotes allows you to search for exact sequences
#The result of the search will be saved as an object (a tibble) called because
because <- search_tweets(q = '"because reasons"', n = 1000, include_rts = FALSE) #Funciona

#Example: look for 1000 tweets (max) with the one of the following words: "latino", "latina", "latinx", with no retweets
#The result of the search will be saved as an object (a tibble) called latinx
latinx <- search_tweets(q = "latino OR latina OR latinx", n = 1000, include_rts = FALSE) #Funciona

##Search by language and word
#Example: look for 1000 tweets (max) in English that have the word "latino" and appear in popular tweets 
#The result of the search will be saved as an object (a tibble) called english
latino <- search_tweets(q = "latino", lang="en", n = 1000, type="popular") 


##Search by key word and geoinformation
#Example: look for 18000 tweets (max) with the word "summer" that appear in mixed tweets 
#geolocated at 50km from Philadelphia
#Geocode format: (latitude, longitude, distance)
#Mixed tweets mean that they come both from the recent and the popular type of tweets
#The result of the search will be saved as an object (a tibble) called summer
summer <- search_tweets(q = "summer", n = 18000, geocode = "39.97,-75.17,50km", type="mixed") 


##Download some user's timeline
#Example: Download last 200 tweets of the user POTUS
#The result of the search will be saved as an object (a tibble) called potus
potus <- get_timeline(user = "POTUS", n = 200)

##Download several users' timelines
#Example: Download last 200 tweets of the users POTUS and FLOTUS
#The result of the search will be saved as an object (a tibble) called potus_flotus
potus_flotus <- get_timeline(user = c("POTUS", "FLOTUS"), n = 200)

##Save the searches to a .csv
#Example: save the last search (summer) as a .csv delimeted by tabs called summer.csv
#Note: you can set the directory (folder) where you want to save these files 
#by clicking in "Files" in the right bottom window, navigating to the desired folder
#and once you're there, clicking in More > Set as working directory
write_delim(summer, "summer.csv", delim = "\t")

#In order to check othe specifications of the functions used, you can run the name of the function
#preceded by a question mark -  a help file will open at the bottom right window
?search_tweets()
?get_timeline()
?search_tweets()


