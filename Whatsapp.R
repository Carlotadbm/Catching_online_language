###Carlota de Benito Moreno
###Catching language data Summer School
###June 23rd 2021
###Convert a Whatsapp text chat into a table

##install library (must be done only once)
install.packages("tidyverse")
##load library (must be done in every new session of RStudio)
library(tidyverse)

##read the file
wa <- read_lines("WhatsApp_multilingual.txt")

##transform it into a dataframe
wa_df <- wa %>% #save it as wa_df
  as_tibble() %>% #convert into a dataframe
  slice(-c(1:2)) %>% #remove the first two rows
  separate(value, into = c("time", "text"), sep = " - ") %>% #separate the single column (value) into two columns: time and text
  separate(time, into = c("date", "time"), sep = " ") %>% #separate column time into date and time
  separate(text, into = c("user", "text"), sep = ": ", extra = "merge") #separate column text into user and text. Because the separator might also appear in text, we add the argument extra

##Anonymise users
#Create table with equivalences between users and random numbers (IDs)
set.seed(3) #set a seed: this will make sure that we always get the same random numbers
users <- wa_df %>% #save it as users
  distinct(user) %>% #Create a list with the unique users we have 
  mutate(ID_user = sample(1000000:9999999, 9)) #create new column ID_user with random numbers

#Replace the information in column user by ID_user
wa_df <- wa_df %>% #modify wa_df
  full_join(users) %>% #join the users table to wa_df
  select(date, time, ID_user, text) #reorder columns and leave out the column with the original user names

##Write the end result as a csv delimited by tabs
wa_df %>% 
  write_delim("WhatsApp_multilingual.csv", delim = "\t")
