
## Load packages
library(tidyr)
library(dplyr)

## Download and unzip the dataset
download.file (url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile ="UCIdataset.zip", method = "curl", cacheOK=FALSE)
unzip(zipfile = "UCIdataset.zip", files = NULL, exdir = "UCIdataset/", unzip = "internal")


## Read in all raw data tables
act.labels <- read.table("/Users/neilagapis/Documents/Coursera/3. Getting and Cleaning Data/Working Directory/Course Project/UCI HAR Dataset/activity_labels.txt")
features <- read.table("/Users/neilagapis/Documents/Coursera/3. Getting and Cleaning Data/Working Directory/Course Project/UCI HAR Dataset/features.txt")
subject_test <- read.table("/Users/neilagapis/Documents/Coursera/3. Getting and Cleaning Data/Working Directory/Course Project/UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("/Users/neilagapis/Documents/Coursera/3. Getting and Cleaning Data/Working Directory/Course Project/UCI HAR Dataset/test/x_test.txt")
y_test <- read.table("/Users/neilagapis/Documents/Coursera/3. Getting and Cleaning Data/Working Directory/Course Project/UCI HAR Dataset/test/y_test.txt")
subject_train <- read.table("/Users/neilagapis/Documents/Coursera/3. Getting and Cleaning Data/Working Directory/Course Project/UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("/Users/neilagapis/Documents/Coursera/3. Getting and Cleaning Data/Working Directory/Course Project/UCI HAR Dataset/train/x_train.txt")
y_train <- read.table("/Users/neilagapis/Documents/Coursera/3. Getting and Cleaning Data/Working Directory/Course Project/UCI HAR Dataset/train/y_train.txt")


## Rename Columns
names(act.labels)[2]<-"Activity"
names(subject_test)[1]<-"Subject"
names(subject_train)[1]<-"Subject"

## Combine x_train and x_test
x<-rbind(x_train,x_test)

## Combine y_train and y_test
y<-rbind(y_train,y_test)

## Combine subject_train and subject_test
subject<-as.vector(rbind(subject_train, subject_test))

## Renaming feature names and combining with new x data frame
features.vec<-as.vector(make.names(features$V2, unique=TRUE))
#features.vec<-as.vector(features$V2)
colnames(x)<-features.vec

## Combine all the data into one main data set
df<-cbind(y,subject,x)
full.df<-merge(act.labels, df, by.x="V1", by.y="V1")
full.df<-full.df[,!(names(full.df) == "V1")]
full.df$Subject <- as.factor(full.df$Subject)

## Extract only the mean and standard deviation (std) of each measurement 
tidy.df <- select(full.df, Subject, Activity, contains("mean"), contains("std"))

## Remove all "meanFreq" and "gravity" columns, as these are not a mean ot std of a measurement
tidy.df <- select(tidy.df, -contains("meanFreq"))
tidy.df <- select(tidy.df, -contains("ravity"))

## Tidy variable names (remove dots caused by forcing unique col names)
names(tidy.df) <- sub("mean", "Mean", names(tidy.df))
names(tidy.df) <- sub("std", "StdDev", names(tidy.df))
names(tidy.df) <- sub("\\.", "", names(tidy.df))
names(tidy.df) <- sub("\\..", "", names(tidy.df))
names(tidy.df) <- sub("\\...", "", names(tidy.df))
names(tidy.df) <- sub("\\.", "", names(tidy.df))

#group the selected data by "Subject" and "Activity" and perform the mean function on all other columns
tidy.temp <- group_by(tidy.df, Subject, Activity)
tidydat <- summarise_each(tidy.temp, funs(mean))

#write the tidy dataset to the current working directory as a .txt file
write.table(tidydat, file = "tidydat.txt", row.names=FALSE)