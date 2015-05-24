# CodeBook ASSIGNMENT 1 - Getting and Cleaining Data Course

This document describes the variables, the data, and any transformations or work performed to clean up the data

##Orginal Data

Original data provided to conduct analysis can be found in the following link
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The zip file contains a folder called 'UCI HAR Dataset' that contains the following files:
* README.txt
* features_info.txt: It conatins information about the variables used in the file features.txt
* features.txt: It contains the list of features
* activity_labels.txt: It contains the names / labels of each one of the activites
* Folder train
  * X_train.txt: Trainind data for the features.  The column names for the training data are in the file features.txt 
  * y_train.txt: Training data for the activities.  
  * subject_train: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30
* Folder test
  * X_test.txt: Test data for the features. The column names for the test data are in the file features.txt
  * y_test.txt: Test data for the activities.
  * subject_test: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30

There are other files in the folder, but for the purposes of this analysis the files listed above are the only ones used.

##Variables

The variables created in the analyis (run_analysis.R) to load, transform and produce final output are the following:
###Loading Original Data
* subject_test: We load in this variable the data from  UCI HAR Dataset/test/subject_test.txt
* X_test: We load in this variable the data from UCI HAR Dataset/test/X_test.txt
* y_test: we load in this variable the data from UCI HAR Dataset/test/y_test.txt
* subject_train: We load in this variable the data from  UCI HAR Dataset/train/subject_train.txt
* X_train: We load in this variable the data from UCI HAR Dataset/train/X_train.txt
* y_train: we load in this variable the data from UCI HAR Dataset/train/y_train.txt
* features: We load in this variable the second column of the file UCI HAR Dataset/features.txt
* activity_lables: We load in this variable the second column of the file UCI HAR Dataset/activity_labels.txt

###Merging Training and Test Data
* subject: We merge subject_test and subject_train data in this variable
* X: We merge X_test and X_train data in this variable
* y: We merge y_test and y_train data in this variable
* merged: We combine all columns from subject, X, y in this variable
* columnNames: We use this variable to combine the column names found in the variable features, with the Subject and Activity columns

###Extracting Measurements on the mean and standard deviation for each measurement
* mean_std_cols: We use this variable to store the names of the columns associated with mean and standard deviation measurements
* subset_mean_std: We use this varialbe to store the subset data from merged with the columns that we require (mean_std_cols), in addition to the subject and the activity

###Independent tidy data set with the average of each variable for each activity and each subject.
* subResult: We use this varialbe to convert and store our data.frame in a data.table object. Hence, we can do fast ordering and grouping
* tidy: We use this variable to store the result of our data set with the averable of each variable grouped by activity and subject.


##Transformations

###Merging Traning and Test Data
We use the functions rbind and cbind to combine the 6 files as ilustraed in the code below.  We also assign 561 column names using the features data.frame, and two additional column names for the subject and the activity.

*NOTE: The result of mergind the data sets is a data.frame with 563 columns and 10299 rows*

```
subject <- rbind(subject_train, subject_test) #subject
X <- rbind(X_train, X_test) #features
y <- rbind(y_train, y_test) #activity

merged <- cbind(subject,y,X)

columnNames <- c("Subject","Activity",features)
colnames(merged) <- columnNames

```
###Extracting Measurements on the mean and standard deviation for each measurement
We use the function grep to extract the columns that contain the word mean() and std(). Furthermore, we take a subset of the merged data based on the columns selected.
```
mean_std_cols <- grep("mean()|std()", names(merged), ignore.case = TRUE)
subset_mean_std <- merged[,c(1,2,mean_std_cols)]
```
###Descriptive activity names
We find each activity id and assign the descriptive name based on the data.frame activity_labels.

```
i = 1
for (act in activity_labels) {
  subset_mean_std$Activity <- gsub(i, act, subset_mean_std$Activity)
  i <- i + 1
}
```

###Appropriately labels the data set with descriptive variable names
Most of the variables are self explanatory; therefore we only change three variables that are in the form of a function and that are important in the analysis: mean, std and freq.

```
names(subset_mean_std)<-gsub("-mean()", "Mean", names(subset_mean_std), ignore.case = TRUE)
names(subset_mean_std)<-gsub("-std()", "Std", names(subset_mean_std), ignore.case = TRUE)
```
###Independent tidy data set with the average of each variable for each activity and each subject.
We transform our subset data.frame into a data.table object to group quicker our results.  The result of applying the averable of each variable for each activity and subject is stored in the variable tidy and exported into a txt file.  We make sure that we set our row names attribute to FALSE, as recommended in the assignment instructions.


```
subResult <- data.table(subset_mean_std)
tidy <- subResult[,lapply(.SD,mean), by="Activity,Subject"]
write.table(tidy,file="tidy.txt",sep=" ",row.names=FALSE)
```

---------------------------------------------------------
##APPENDIX
The following information can be found in the original files.  However, it's been added here for facility to the reader:

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value **This variable is changed for Mean in the output file**
std(): Standard deviation **This variable is changed for Std in the output file**
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'