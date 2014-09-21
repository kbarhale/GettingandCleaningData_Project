## Include the reshape2 package

library(reshape2)

## Set the file path and working directory for the data.


filepath<- "C://Users/Koushik/Desktop/CourseProjectData"
setwd(filepath)
unzip("getdata-projectfiles-UCI HAR Dataset.zip")
## Read the Activities Label file
activity_labels <-read.table("./UCI HAR Dataset/activity_labels.txt")
View(activity_labels)

##Change the Column names to Activity_ID, Activity_Names
ActivityLabels<-c("Activity_ID", "Activity_Names")
colnames(activity_labels) <-ActivityLabels
View(activity_labels)

## Read the Features file
features <-read.table("./UCI HAR Dataset/features.txt")
View(features)

## Change the column Names to Feature_ID, Feature_Name
FeatureLabels <-c("Feature_ID","Feature_Name")
colnames(features) <-FeatureLabels
View(features)

## Test Data

## Read the subject_test file
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
View(subject_test)

## Change the Column Label to SubjectID
subject_test_labels <-c("SubjectID")
colnames(subject_test) <-subject_test_labels
View(subject_test)

## Read the X_test file
X_test <-read.table("./UCI HAR Dataset/test/X_test.txt")
View(X_test)

## Change the Column Label to FeatureNames
colnames(X_test) <-features$Feature_Name
View(X_test)

## Read the Y_test file and change the label to Activity_ID
## We use it in this format because the $ operator used in earlier steps 
##is not valid for atomic vectors.

Y_test <-read.table("./UCI HAR Dataset/test/Y_test.txt", col.names =c("Activity_ID"))
View(Y_test)

## Create the combined Test File
Test <-cbind(subject_test,X_test,Y_test)
View(Test)

## Train Data

## Read the subject_train file
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
View(subject_train)

## Change the Column Label to SubjectID
subject_train_labels <-c("SubjectID")
colnames(subject_train) <-subject_train_labels
View(subject_train)

## Read the X_train file
X_train <-read.table("./UCI HAR Dataset/train/X_train.txt")
View(X_train)

## Change the Column Label to FeatureNames
colnames(X_train) <-features$Feature_Name
View(X_train)

## Read the Y_train file and change the label to Activity_ID
## We use it in this format because the $ operator used in earlier steps 
##is not valid for atomic vectors.

Y_train <-read.table("./UCI HAR Dataset/train/Y_train.txt", col.names =c("Activity_ID"))
View(Y_train)

## Create the combined Train File
Train <-cbind(subject_train,X_train, Y_train)
View(Train)

## Append the Test data with the Train data using the rbind statement
Complete_Data <- rbind(Test,Train)
View(Complete_Data)


## Look for Columns Refering to Means in the Complete Data
mean_index <- grep("mean",names(Complete_Data),ignore.case=TRUE)
mean_Columns <- names(Complete_Data)[mean_index]

## Look for Columns Refering to Standard Deviation in the Complete Data
stddev_index <- grep("std",names(Complete_Data),ignore.case=TRUE)
stddev_Columns <- names(Complete_Data)[stddev_index]

## Subset the Data to include only the columns having mean and standard 
##deviation data

MeanStdDev_Data <-Complete_Data[,c("SubjectID","Activity_ID",mean_Columns,
        stddev_Columns)]
View(MeanStdDev_Data)

## Merge the Activity Names with the data for Mean and Standard Deviation based 
## on the Activity ID.

Data_with_ActivityNames <- merge(activity_labels, MeanStdDev_Data,
        by.x = "Activity_ID",by.y = "Activity_ID", all = TRUE)
View(Data_with_ActivityNames)

##Melting the Data
MeltData <- melt(Data_with_ActivityNames,id=c("Activity_ID","Activity_Names"
        ,"SubjectID"))

## Cast the Data according to the Average of each activity, Subject and feature
Mean <- dcast(MeltData,Activity_ID + Activity_Names + SubjectID 
        ~ variable,mean)

## Output the Data

write.table(Mean,"./Tidy_Data.txt",sep = " ",eol = "\n", na = "NA", dec = ".",
        row.names = TRUE,col.names = TRUE)


Tidy_Data<- read.table("./Tidy_Data.txt")
View(Tidy_Data)