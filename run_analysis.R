# run_analysis.R
# The code below loads data from test and training sets.  The data is merged and a subset is created 
# containing only the measurements on the mean and standard deviation for each measurement.
# The output of the script is a file with the average of each variable for each activity and each subject.

## Check if libraries dplyr and data.table are installed.
if (!require("dplyr")) {
  install.packages("dplyr")
}

if (!require("data.table")) {
  install.packages("data.table")
}

require("dplyr")
require("data.table")

## Read test data files  
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)  
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)  
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE) 

## Read training data files 
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)  
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)  
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)  

## Read features and activity_labels
features <- read.table("UCI HAR Dataset/features.txt", header = FALSE, colClasses="character")[,2]
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, colClasses="character")[,2]

## 1. Merges the training and the test sets to create one data set.
subject <- rbind(subject_train, subject_test) #subject
X <- rbind(X_train, X_test) #features
y <- rbind(y_train, y_test) #activity

merged <- cbind(subject,y,X)

columnNames <- c("Subject","Activity",features)
colnames(merged) <- columnNames

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 

mean_std_cols <- grep("mean()|std()", names(merged), ignore.case = TRUE)

subset_mean_std <- merged[,c(1,2,mean_std_cols)]

#3. Uses descriptive activity names to name the activities in the data set
i = 1
for (act in activity_labels) {
  subset_mean_std$Activity <- gsub(i, act, subset_mean_std$Activity)
  i <- i + 1
}

#4. Appropriately labels the data set with descriptive variable names.
names(subset_mean_std)<-gsub("-mean()", "Mean", names(subset_mean_std), ignore.case = TRUE)
names(subset_mean_std)<-gsub("-std()", "Std", names(subset_mean_std), ignore.case = TRUE)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.

subResult <- data.table(subset_mean_std)
tidy <- subResult[,lapply(.SD,mean), by="Activity,Subject"]
write.table(tidy,file="tidy.txt",sep=" ",row.names=FALSE)

