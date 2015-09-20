setwd("C:/Users/logo403/Documents/R/work/datacleaning/")

#Call the function dplyr for variable selection and other features
library(dplyr)

###################################################################
# 1. Merges the training and the test sets to create one data set #
###################################################################
# Read train and test sets
trainFeature <- read.table("./UCI HAR Dataset/train/X_train.txt")
testFeature <- read.table("./UCI HAR Dataset/test/X_test.txt")
# Merge the two file
traintestFeature <- rbind(trainFeature, testFeature)

###################################################################
# 2. Extracts only the measurements on the mean and standard      #
#    deviation for each measurement                               #
###################################################################
# Read feature name file and identify index where mean and std variables 
# of interest "time Body Accelerometer Magniture" are
featureName <- as.character(read.table("./UCI HAR Dataset/features.txt")[,2])
# Find the index of the mean and std
featind <- c(grep("tBodyAccMag-mean()",featureName, fixed = TRUE),
             grep("tBodyAccMag-std()",featureName, fixed = TRUE))
# Extract the measurements on the mean and standard deviation
reducedFeature <- traintestFeature[,featind]

#############################################################################
# 3. Uses descriptive activity names to name the activities in the data set #
#############################################################################
# Add activity code to the data set
# Read train and test activity codes 
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt",
                            col.names = "activityid")
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt",
                           col.names = "activityid")
# Merge the activity codes to the feature file
reducedFeature <- cbind(rbind(trainActivity, testActivity),reducedFeature)

# read file with activity description and join the tables and remove activity id
activityDescription <- read.table("./UCI HAR Dataset/activity_labels.txt",
                       col.names = c("activityid", "activity"))
reducedFeature <- left_join(reducedFeature, activityDescription, 
                            by = "activityid") %>% select(-activityid)

########################################################################
# 4. Appropriately labels the data set with descriptive variable names #
########################################################################
# We will use the index above (element featind defined at step 2) to 
# select the appropriate variable names before naming the columns
colnames(reducedFeature) <- c("tBodyAccMag_mean","tBodyAccMag_std","activity")

###############################################################################
# 5. From the data set in step 4, creates a second, independent tidy data     #
#    set with the average of each variable for each activity and each subject #
###############################################################################
# Add subject to the data set - same approach as activity above see item 3
# and remove variable "tBodyAccMag-std"
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                           col.names = "subjectid")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt",
                          col.names = "subjectid")
secondData <- cbind(rbind(trainSubject, testSubject),reducedFeature)
# summarize file by subject and activity
meanFeature <- secondData %>% select(-tBodyAccMag_std) %>%
        group_by(activity,subjectid) %>% summarize_each(funs(mean))

library(tidyr)
meanFeature <- spread(meanFeature,activity,tBodyAccMag_mean)

#########################################
# Export file for assignment submission #
#########################################
write.table(meanFeature, file = "tidydataset.txt", row.names = FALSE)

#########################
# Code to read the file #
#########################
meanFeat <- read.table("tidydataset.txt", header = TRUE)
