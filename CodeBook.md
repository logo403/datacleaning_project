==================================================================
Human Activity Recognition Using Smartphones
Time Body Accelerometer Magnitude Dataset
Code Book
==================================================================

Description
=========================================
    The experiments from which this was created have been carried out with a group of 
    30 volunteers within an age bracket of 19-48 years. Each person performed six activities 
    (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone 
    (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
    several measures through sensor signals were recorded and pre-processed. The measure that 
    was retained for this project is the magnitude of body acceleration three-dimensional signals 
    within a certain time domain.


Variables
=========================================
    1.Measure: Averaged normalized three-dimensional Time Body Accelerometer Magnitude 
    2.Activity (6): Walking, Walking upstairs, Walking downstairs, Sitting, Standing, Laying

Data
=========================================
    1.File name: tidydataset.txt
    2.Structure: The dataset has 7 columns (subjectid, Walking, Walking upstairs,
    Walking downstairs, Sitting, Standing, Laying) and 30 rows. Each row represents one 
    of the 30 volunteers within an age bracket of 19-48 years. Each volunteers 
    (also called subjects) performed the 6 prescribed activities.


Transformations
=========================================
    The original measure of the Time Body Accelerometer Magnitude had three dimensions. 
    A three-cimensional signal was calculated by using the Euclidean norm before being 
    normalized. The data set contains the average of this derived measure.


