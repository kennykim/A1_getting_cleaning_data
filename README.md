# README ASSIGNMENT 1 - Getting and Cleaning Data Course

This document describes the requirements to complete the assignment 1.

## Instructions
The data for the project is found in the following link: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The R script called run_analysis.R that does the following. 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each   variable for each activity and each subject.

## Content of the Repo
This Repository includes the following files in addition to the README.md:
1. CodeBook.md: Describes the variables, the data, and any transformations or work performed to clean up the data
2. tidy.txt: Result from the script  with the average of each variable for each activity and each subject
3. run_analysis.R: the script that performs the analysis


## Using the Script

### Assumptions
The script assumes that a folder 'UCI HAR Dataset' is located in the same directory than script and it contains the test, train and labels data.

### Libaries Used
The script requires the following libraries:
1. data.tables
2. dplyr

### How the scripts work?
The script that performs the analysis is called run_analysis.R.  This script will check if your R instance has installed the libraries required above. If they are not installed, the script will install them.

Then the script will load the test, training and labels information. The script was created assuming that all required files are in the folder 'UCI HAR Dataset'.   The script will conduct the required analysis, and will create a file called tiny.txt in the same directory where the script is being executed. 

*NOTE: Detailed information of the functions and varialbes can be found in the Code Book (CodeBook.md)*
