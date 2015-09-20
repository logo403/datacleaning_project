# datacleaning_project
Data cleaning project: tidy data set

==================================================================
Human Activity Recognition Using Smartphones
Time Body Accelerometer Magnitude Dataset
ReadMe
==================================================================

Origin of the dataset 
=========================================

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

    1. Download zip file above in your R working folder and unzip it
    2. Run the R script accompanying this documentation

Description of the dataset
=========================================
    The experiment from which this was created have been carried out with a group of 30 
    volunteers within an age bracket of 19-48 years. Each person performed six activities 
    (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a 
    smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and 
    gyroscope, several measures through sensor signals were recorded and pre-processed. 
    The measure that was retained for this project is the magnitude of body acceleration 
    three-dimensional signals within a certain time domain.

  
The dataset includes the following files:
=========================================
    - "README.md"
    - "CodeBook.md" : file explaining the structure of the "tidydataset.txt" file
    - "run_analysis.R" : R script to run the tidy data set
    - "tidydataset.txt" : File with 30 rows (subjects) and 6 variables (activity)
    - 
  
R script
=========================================
    Name: run_analysis.R
    Location: GitHub and at the bottom of the README.md file
    Function: put and generates a tidy data text file (wide form) that meets the 
        principles of tidy data learn in the "Getting and cleaning data" course on Coursera
    Details:
        1. Merges the training and the test sets to create one data set.
        2. Extracts the measurement of the mean and the standard deviation for the Time Body 
            Accelerometer Magnitude (tBodyAccMag) variable. 
        3. Incorporates descriptive activity names to the data set.
        4. Labels the data set with descriptive variable names. 
        5. From the data set in step 4, creates an independent tidy data set called 
            "tidydataset.txt" with the average of tBodyAccMag for each activity and each subject.
    
To read the tidy data set (2 methods)
=========================================
    Method 1: 
        # download the file "tidydataset.txt" onto your R working folder and run the following R line
        data <- read.table("tidydataset.txt", header = TRUE)
        View(data)
    
    Method 2:
        # run the following script from your computer. You may need this library "psych"
        address <- "https://s3.amazonaws.com/coursera-uploads/user-20335b273948a6fc1229ac0a/975116/asst-3/ee42ca305f3811e5b7c571c45f55f078.txt"
        address <- sub("^https", "http", address)
        data <- read.table(url(address), header = TRUE) 
        View(data)
  
run_analysis.R
=========================================
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
    data <- read.table("tidydataset.txt", header = TRUE)

