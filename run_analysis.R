library(dplyr)
library(readr)
library(reshape2)
library(stringr)





#Reading X train and X test sets
read_tx_as_DF_X <- read.table("UCIHARDataset/train/X_train.txt", colClasses = "numeric")
read_tes_as_DF_X <- read.table("UCIHARDataset/test/X_test.txt", colClasses = "numeric")

# Merging x - train and test sets
x_row <- rbind(read_tx_as_DF_X, read_tes_as_DF_X)


#Reading Y train and Y test sets
read_tx_as_DF_Y <- read.table("UCIHARDataset/train/Y_train.txt", colClasses = "factor")
read_tes_as_DF_Y <- read.table("UCIHARDataset/test/Y_test.txt", colClasses = "factor")

#Reading Subject from train and test sets
read_tx_as_DF_sub <- read.table("UCIHARDataset/train/subject_train.txt", colClasses = "factor")
read_tes_as_DF_sub <- read.table("UCIHARDataset/test/subject_test.txt", colClasses = "factor")

colnames(read_tes_as_DF_sub) <- c("subject")
colnames(read_tx_as_DF_sub) <- c("subject")

summary(read_tx_as_DF_sub)
summary(read_tes_as_DF_sub)

#Merging subject train and test rows
sub_row <- rbind(read_tx_as_DF_sub, read_tes_as_DF_sub)

# Replacing Y levels to activities
summary(read_tx_as_DF_Y)
summary(read_tes_as_DF_Y)
activities <- c("walking", "walking_downstairs","walking_upstairs","sitting","standing","laying")
colnames(read_tx_as_DF_Y) <- c("activity")
attr(read_tx_as_DF_Y$activity, "levels") <- activities

colnames(read_tes_as_DF_Y) <- c("activity")
attr(read_tes_as_DF_Y$activity, "levels") <- activities

# Merging Y - train and test sets
y_row <- rbind(read_tx_as_DF_Y, read_tes_as_DF_Y)


# Names read from features text doc and name x_row data set
nam_es <- read.table("UCIHARDataset/features.txt")
nam_es

names(nam_es)

# changing column names for proper meaning
x <- as.character(gsub("\\()", "", nam_es$V2))
x <- as.character(gsub(",", "_", x))
x <- as.character(gsub("-", "_", x))
x <- as.character(gsub("fBodyBody", "fBody", x))
x <- as.character(gsub("Mean", "mean", x))
x<- paste0(x,"_",c(1:length(x)))


length(x)
colnames(x_row) <- x

#Filtering the dataset for mean and std from x_row
f_o_std <- filter(x_row[(grepl("std", x))] )

names(f_o_std)

f_o_mean <- filter(x_row[(grepl("mean", x))] )

names(f_o_mean)


#creating a dat set 
myDF <- cbind(sub_row, y_row, f_o_mean, f_o_std)

test_names <- names(myDF)

test_names

#writing the data set in csv file
write.csv(myDF, "./final_out.csv")


#Reading the features from the features info
lines_txt <- readLines("UCIHARDataset/features_info.txt", 30)
tmp <- lines_txt[13:29]
x_col_names = c()

#creating final Data Frame for the average of all subjects per
# activity
finalDF <-data.frame(row.names=1:length(y_row))

j= 1

#Make a list without XYZ by combining their average for mean
for (i in 1:length(tmp)){
  val <- tmp[i]
  val <- strsplit(val, "-XYZ")[[1]]
  val <-  paste0(val,"_mean")
  #use val to grep the column names and 
  tmp1 <- myDF %>% select(contains(val)) 
  x_col_names[j] <- val
  j= j+1
  y <- rowMeans(tmp1)
  finalDF <- cbind(finalDF, y)
  
}

#Make a list without XYZ by combining their average for std
for (i in 1:length(tmp)){
  val <- tmp[i]
  val <- strsplit(val, "-XYZ")[[1]]
  val <-  paste0(val,"_std")
  #use val to grep the column names and 
  tmp1 <- myDF %>% select(contains(val)) 
  x_col_names[j] <- val
  j= j+1
  y <- rowMeans(tmp1)
  finalDF <- cbind(finalDF, y)
}

colnames(finalDF) <- x_col_names

finalDF <- cbind(sub_row, y_row, finalDF )
#head(finalDF, n=10)

head(finalDF, n=3)  
dim(finalDF)


summary(finalDF)

#myf_d <- finalDF %>% group_by(activity) %>% summarise_if(is.numeric, mean, na.rm = TRUE)

#head(myf_d, n=6)

write.table(finalDF, "./final_output.txt", row.names = FALSE)


