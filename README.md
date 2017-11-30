#Getting and Cleaning Data - Project

## Getting the data from text files
* Downloaded the data set and unzipped the same in working directory
* Visually inspected the files to understand the dataset 
* Found that X had the signals information from samsung smart phone and Y had the
information of what activities were performed
* Provided the right path, the data files were read for train and test sets as numeric form for X variables and factors for Y variables.
* saved the read X tables and Y tables in different data frames

## Combining train and Test sets
* Using rbind function in R the train and test sets of X  and Y were merged


## Naming the columns and cleaning columns

* Y set had activity information and hence the name was choosen as activity and assinged using colnames()

* X set had 561 variables, and it mached the list availble in the features.txt file.
* names were read from that file and the names are modified using find and replace functions like gsub(), paste0 functions.

* Unique variable names were coined by adding the column numbers to the string of variables. 

## Renaming factors for new attributes

*  For y sets, the levels are 6. They represent activities like walking, walking_upstairs, walking_downstairs, sitting, standing and laying.

* Attribute function of levels are set with above mentioned activities and now the
dataset contains meaningful activity names instead of 1 to 6 numeric numbers.


## Merging data sets to get clean data

* Above cleaned x and y sets were merged using cbind() function and retained column names

## Obtaining a dataset from subset of the merged data

* From above dataset, read the common columns of smart phone interial signals, 
and combined them using the means and average. rowMeans() function was used for
every group available in the subset and average mean for the variables formed 
the columns

## Finding average alias mean on data

* For every activity, the columns means were computed and stored in the text files.


## storing results