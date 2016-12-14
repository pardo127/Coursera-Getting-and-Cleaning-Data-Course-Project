# Dowloading

 if(!file.exists("./data"))
   {
    dir.create("./data")
   }

 fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

 download.file(fileUrl,destfile="./data/Dataset.zip")

 unzip(zipfile="./data/Dataset.zip",exdir="./data")
 
 # Reading testing and training tables
 
 x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
 
 y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

 subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

 x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

 y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")

 subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

 features <- read.table('./data/UCI HAR Dataset/features.txt')

 activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

 # Allocating column names

 colnames(x_train) <- features[,2] 

 colnames(y_train) <-"activityId"
 
 colnames(subject_train) <- "subjectId"

 colnames(x_test) <- features[,2] 
 
 colnames(y_test) <- "activityId"

 colnames(subject_test) <- "subjectId"

 colnames(activityLabels) <- c('activityId','activityType')

 # Merging data

 mrg_train <- cbind(y_train, subject_train, x_train)
 
 mrg_test <- cbind(y_test, subject_test, x_test)
 
 setAll <- rbind(mrg_train, mrg_test)

 colNames <- colnames(setAll)

 # Defining ID, mean, standard deviation

 mean_std <- (
                 grepl("activityId" , colNames) | 
                 grepl("subjectId" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
              )

 setMeanAndStd <- setAll[ , mean_std == TRUE]

 # Naming activities in data set

 setWithActivityNames <- merge(setMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

 # Creating the new data set (averae for variables and activities)

 TidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)

 TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]

 write.table(TidySet, "average_data.txt", row.name=FALSE)
