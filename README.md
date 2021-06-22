# Catching online language
 
In this repository you will find the files and R Scripts used in the session "Catching online language" that will take place at the Summer School "Catching language", hosted by the University of Bologna (21-25 June 2021).

Please download them into a single folder that you can locate easily in your computer.

## Swirl course
This workshop has an accompanying swirl course. This is an interactive R course that will let you practice and learn how to deal with the packages we worked, working directly in R. In order to access it, you will need to do the following on R (as always, I recommend that you do it on RStudio):

### Install package "swirl"
installed packages do not normally need to be reinstalled, unless you want to update them. However, I might update the swirl courses if I detect errors and mistales, so I recommend that you reinstall it if the last time you used it was long ago.

`install.packages("swirl")`

### Load library "swirl"
Libraries, on the contrary, must be loaded everytime you start a new session in RStudio/R. (Quotations are not needed here, but are also possible.)

`library(swirl)`

### Installing swirl courses
When you open swirl for the first time, it offers you some preloeaded courses (after asking for your name… every time, sorry about that). This course is not preloaded, so you’ll have to install it from Github. This is the code you’ll need (note that the package swirl needs to be loaded, because the install_course_github() function belongs to that package):

`library(swirl)`
`install_course_github(
  "Carlotadbm", 
  "Catching_online_language_swirl")`
`swirl() #to begin`

If you are unfamiliar with R, I absolutely recomment that you also try the preloaded cours "R Programming" course. Sometimes swirl doesn’t offer you the preloaded courses, maybe because it detected that you had installed another course and thinks you’re over them… I don’t know exactly why, but it happens. Anyway, you can easily install the R programming course from github too, with the following code:

`install_course_github(
  "seankross", 
  "R_programming")`

If you're also interested in learning how to perform data cleaning and transformation and text analysis and processing in R, I have a swirl course which you might enjoy:

`install_course_github(
  "Carlotadbm", 
  "Tools_for_text_analysis")`

Try it out… and enjoy!
