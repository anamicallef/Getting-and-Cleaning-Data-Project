Getting-and-Cleaning-Data-Project
===============================



This repository contains the files to get a tidy data from the data provided in the project of Getting and Cleaning Data course.



The files included in this repository are:


- run_analysis.R
- README.md
- CodeBook.md


#run_analysis.R

This script assumes that you have download and unzip the files provided by the assignment and that you have set the working directory in the unzip directory.


##Script details:

- First the script reads "X_train.txt" and "X_test.txt" data files:

```r
#Reading data
TrainData <- read.table("train/X_train.txt", header=F, sep="")
TestData <- read.table("test/X_test.txt", header=F, sep="")
```

- Then, it merges both data sets combining both by rows

```r
#Merging training and test sets to create one data set
data<-rbind(TrainData,TestData)
```

- It uses the provided file "features.txt" to identify those variables that are measures of means or standard deviations. To do this, it creates an index 

with the row numbers containing the text "-mean()" or "-std()-". Then, it subsets the data set by the rows matching that index.

```r
#Extracting only mean and standard deviation for each measurement
features <- read.table("features.txt", header=F, sep="")
index<-features[ with(features,  grepl("-mean()-", V2,fixed=TRUE) | grepl("-std()-", V2,fixed=TRUE)),1]
data<-data[,index]
```

- Then, it uses the second column of "feature.txt" to give a name to the variables contained in the new data set, considering only the row numbers included 

in "index"

```r
#Naming variables in the data set
colnames(data)<-features[index,2]
```

- To add information about activity classes and its names, it reads "y_train.txt" and "y_test.txt" and combines both by rows. It also reads "activity_labels.txt" to use the activity names to create a new factor added to the data file.

```r
#reading data to add activity classes in the data set
yTrainData <- read.table("train/y_train.txt", header=F, sep="")
yTestData <- read.table("test/y_test.txt", header=F, sep="")
ActivityData<-rbind(yTrainData,yTestData)

#Adding activity variable and names
ActivityNames<-read.table("activity_labels.txt", header=F, sep="")
data$activity<-factor(ActivityData$V1,labels=ActivityNames[,2])
```

- It also reads subject data from "train/subject_train.txt" and "test/subject_test.txt", merges both by rows and adds the data as a new variable to the data 

set

```r
#reading data to add subject data in the data set
subjectTrainData <- read.table("train/subject_train.txt", header=F, sep="")
subjectTestData <- read.table("test/subject_test.txt", header=F, sep="")

#Adding subject variable
SubjectData<-rbind(subjectTrainData,subjectTestData)
data$subject<-SubjectData$V1
```

- To create a tidy data set as requested it uses the function aggregate, that calculates the mean of each variable for each subject and activity

```r
#creating a new data set with the average of each variable for each activity and each subject
tidyData<-aggregate(data[,1:48], by=list(activity=data$activity,subject=data$subject), FUN=mean, na.rm=TRUE)
```

- Finally it exports the new tidy data frame to the working directory with the name "tidyData.txt"

```r
#exporting the tidy data frame
write.table(tidyData, file="tidyData.txt", sep=" ")
```


#CodeBook.md
This file contains more detail about the variables in "tidyData.txt"

