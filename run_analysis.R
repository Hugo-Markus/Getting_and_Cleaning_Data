# Load dplyr library
library(dplyr)
# Getting and Cleaning Data


# Create data directory
if(!file.exists("./data")){dir.create("./data")}

# Download dataset
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile="./data/dataset.zip")

# Unzip files of the dataset
unzip(zipfile = "./data/dataset.zip", exdir = "./data")



# MERGE TRAIN AND TEST SETS

# Read train data
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
Subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Read test data
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
Subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Read vector with all features
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Read vector with all activity labels
activity_labels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# Assign column names to tables
colnames(X_train) <- features[,2]
colnames(X_test) <- features[,2]
colnames(Y_train) <- "ActivityID"
colnames(Y_test) <- "ActivityID"
colnames(Subject_test) <- "SubjectID"
colnames(Subject_train) <- "SubjectID"
colnames(activity_labels) <- c("ActivityID", "Activity")

# Merge the datasets
merged_train <- cbind(Y_train, Subject_train, X_train)
merged_test <- cbind(Y_test, Subject_test, X_test)
merged_all <- rbind(merged_train, merged_test)

# All column names
column_names <- colnames(merged_all)

# Collect all columns that contain the words "mean" or "std"
mean_and_std <- (grepl("ActivityID" , column_names) | 
                   grepl("SubjectID" , column_names) | 
                   grepl("mean" , column_names) | 
                   grepl("std" , column_names) 
)

# Make a new subset of column for mean and std
mean_and_std_subset <- merged_all[ ,mean_and_std]

# Add descriptive activity names to the activites
activity_names_subset <- merge(mean_and_std_subset, activity_labels, 
                               by = "ActivityID", all.x = TRUE)

# Descriptive variable names have been added already!

# Aggregate dataset to get the average of each variable for each activity and each subject
new_tidy_subset <- aggregate(. ~SubjectID + ActivityID, activity_names_subset, FUN = function(x) mean(as.numeric(as.character(x))))

# Order the rows by the SubjectID and ActivityID
new_tidy_subset <- arrange(new_tidy_subset, SubjectID, ActivityID)

# Export tidy dataset
write.table(new_tidy_subset, "TidyDataset.txt", row.name=FALSE)
# Done!







