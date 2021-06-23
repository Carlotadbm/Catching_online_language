###Carlota de Benito Moreno
###Catching language data Summer School
###June 23rd 2021
###Web scraping with rvest and polite

##install library (must be done only once)
install.packages("tidyverse") #rvest library is included
install.packages("polite")
install.packages("xml2")
install.packages("rvest")
##load library (must be done in every new session of RStudio)
library(tidyverse)
library(polite)
library(xml2)
library(rvest)


#### Create a corpus of blog posts

###Explore the html structure
# Let's frist explore the website we want to scrape read_html(), save it as semevadelalengua
semevadelalengua <- read_html("http://www.semevadelalengua.es/")
semevadelalengua #check the object to see how it looks like

# HTML structures is rather complicated. We can check its structure with html_structure(), but it's
# hard to read
semevadelalengua %>% 
  html_structure()

# I actually recommend to open the website in your preferred explorer and check the source code (right click
# on the website)
# It's useful to look for key words within the source code to find your way to the information you'll need.


### Scraping several posts

## Bow
# This website has 10 different posts, which we would like to download
# Because we're going to bulk download data, we'll use the polite package, which helps us scrape respecting
# the wishes of the creator of the website.

host <- "http://www.semevadelalengua.es/" #save the name of the website as host
session <- bow("http://www.semevadelalengua.es/", #perform the bow; adapt the user_agent (which lets know 
               #the owner of the website who you are, what are you doing and how to contact you)
               #save the bow as session
               user_agent = "Carlota de Benito Moreno - looking for linguistic data - https://www.spur.uzh.ch/en/aboutus/Personen/staff/carlotadebenito.html",
               force = TRUE) 

## Discover the paths of each particular URL
# Each of the posts we're interested in has it's own id. The URLs follow this format:
# http://www.semevadelalengua.es/?p=838
# The number that follows the parameter `p` is included in the HTML as the attribute `id` of the element `article`
# Let's find the post's ids and save it as ids
ids <- scrape(session) %>% #scrape the host website
  html_elements("article") %>% #find the html element `article`
  html_attr("id") #retrieve is attribute `id`
ids #now we have a character vector with the 10 different ids

ids_clean <- ids %>% #because we don't need the string `post-`, we remove it from each element
  str_remove("post-") #we use str_remove() for that
ids_clean #check it out

## Scrape each URL and save the result as `posts_lengua`
posts_lengua <- map(ids_clean, #map indicates that we'll apply a function to each element of a vector (`ids_clean`)
                    ~scrape(session, query = list(p=.x)))  #the function is `scrape`. With the argument `query`
    #we indicate that each element of `ids_clean` (.x) is part of the parameter `p` of the URL (http://www.semevadelalengua.es/?p=838)
posts_lengua #check it out -  we have a list of 10 elements, which are the HTML of each URL

## Retrieve the text content of each article, which is stored in elements `p`
content_lengua <- map(posts_lengua, #map() indicates that we'll apply a function to each element of a list (`posts_lengua`)
               ~html_elements(.x, "p") %>% #the function is html_elements(): .x means 'apply to every 
                 #element of the list, while "p" indicates the element to be retrieve
                 #note that we have a pipe (%>%) within our map() function, because we'll map something else:
                html_text2()) #with html_text2() we retrieve the text of each element
content_lengua #check it out - we again have a list of 10 elements, each of which contains a vector of each 
  #paragraph (`p` element)

## Transform it into a tibble 
content_lengua_tb <- content_lengua %>% 
  tibble(posts = .) %>% #with the tibble() we create a tibble with a single column, called `posts`
  #each row is a list right now
  mutate(id = ids_clean) %>% #we add a new column with the id of each article
  unnest_auto(posts) #we unnest column `posts`, so that each row is an actual paragraph
content_lengua_tb #check it out

## Save it to a csv file called "content_lengua_tb.csv" and delimited by tabs
write_delim(content_lengua_tb, "content_lengua_tb.csv", delim = "\t")
  

