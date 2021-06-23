###Carlota de Benito Moreno
###Catching language data Summer School
###June 23rd 2021
###Access to Tumblr with tumblr

##install library (must be done only once)
install.packages("tumblR")
install.packages("httr")
install.packages("tidyverse")
##load library (must be done in every new session of RStudio)
library(httr)
library(tumblR)
library(tidyverse)


##Authenticate in Tumblr
#You will need to put your data from your own Tumblr API
#You can do that here (you'll need to create a Tumblr account):
#https://www.tumblr.com/oauth/apps
app <- oauth_app(appname = "your_appname", 
                 key = "your_consumer_key", 
                 secret = "your_consumer_secret")	
endpoint <- oauth_endpoint(request = 'http://www.tumblr.com/oauth/request_token', 
                           authorize = 'http://www.tumblr.com/oauth/authorize', 
                           access = 'http://www.tumblr.com/oauth/access_token')
#After running the next line  you will be asked if you want to use a local file: the easiest is to say no. 
#Type 2 in the console and run it by pressing enter
sig <- sign_oauth1.0(app, 
                     token = "your_token",
                     token_secret = "your_token_secret")
#Save your api_key
api_key <- "your_api_key"


##Download posts from a given Tumblr
#It can only donwload 20 posts at a time, but you can set at what post it starts with the argument offset
#Run ?posts to know more about that

#Example: download 20 text posts from didyouknowblog.com/ and save it as text_posts
text_posts <- posts(base_hostname = "didyouknowblog.com/", type = "text", api_key = api_key)
#Example: download 20 photo posts from didyouknowblog.com/ and save it as photo_posts
photo_posts <- posts(base_hostname = "didyouknowblog.com/", type = "photo", api_key = api_key)
#The argument type sopports the following type of posts: text, photo, quote, link, chat, audio, video, answer
#Run ?posts to know more about that

##Convert our searches into a tibble
#Objects text_posts and photo_posts are complicated lists
#We're interested in the element "response" of the list

text_posts_df <- text_posts$response %>% #save it as text_posts_df
  as_tibble() %>% #transform it into a tibble
  select(posts) %>% #we're interested in column posts, which is also a list. We select it
  unnest_auto(posts) %>% #We unnest it (to get the elements saved in the list)
  select(id, date, body, summary) #each post is a row. They have a lot of associated metadata, let's select id, date, body and summary


photo_posts_df <- photo_posts$response %>% #save it as photo_posts_df
  as_tibble() %>% #transform it into a tibble
  select(posts) %>% #we're interested in column posts, which is also a list. We select it
  unnest_auto(posts) %>% #We unnest it (to get the elements saved in the list)
  select(id, date, body, summary) #each post is a row. They have a lot of associated metadata, let's select id, date, body and summary

##Put both dataframes together and write them into a .csv file
corpus_tumblr <- photo_posts_df %>% #save it as corpus_tumblr
  add_row(text_posts_df) 

corpus_tumblr %>% #write it as a .csv file delimited by tabs
  write_delim("corpus_tumblr.csv", delim = "\t")

### Find out the 20 most frequent content words in the summary field with the library tidytext
##install library (must be done only once)
install.packages("tidytext")
install.packages("tidyverse")
install.packages("stopwords")
##load library (must be done in every new session of RStudio)
library(tidyverse)
library(tidytext)
library(stopwords)

##Read .csv file
corpus_tumblr <- read_delim("corpus_tumblr.csv", delim = "\t")

corpus_tumblr_words <- corpus_tumblr %>% 
  unnest_tokens(word, summary, token = "words", to_lower = TRUE) %>% #tokenize column summary (transformed to lower case) and save each separate word in a column called word
  count(word, sort = T) #create a sorted table that counts each unique word

##Remove stopwords
stopwords_getlanguages("snowball") #check supported languages in the "snowball" package of library "stopwords"
en_sw <- get_stopwords("en") #save English stopwords as en_sw
corpus_tumblr_words %>%
  anti_join(en_sw) %>% #remove rows in corpus_tumblr_words whose word value matches word in en_sw
  top_n(n = 20) %>% #select top 20
  ggplot(aes(y = n , x = reorder(word,n))) +
  geom_col(fill = "darkgreen") +
  coord_flip() + 
  theme_linedraw() + 
  labs(title = "20 most common words in 'Did you know' Tumblr", x = "Words", y = "Absolute frequency") 

###N-grams
## Find out the frequency 2-grams in the summary field
corpus_tumblr %>% 
  unnest_tokens(ngrams, summary, token = "ngrams", n = 2, to_lower = TRUE) %>% #tokenize column summary (transformed to lower case) and save each separate 2-gram in a column called ngrams
  count(ngrams, sort = T) #create a sorted table that counts each unique ngram
