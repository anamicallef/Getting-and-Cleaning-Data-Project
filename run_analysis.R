
#Reading data
TrainData <- read.table("train/X_train.txt", header=F, sep="")
TestData <- read.table("test/X_test.txt", header=F, sep="")

#Merging training and test sets to create one data set
data<-rbind(TrainData,TestData)

#Extracting only mean and standard deviation for each measurement
features <- read.table("features.txt", header=F, sep="")
index<-features[ with(features,  grepl("-mean()-", V2,fixed=TRUE) | grepl("-std()-", V2,fixed=TRUE)),1]
data<-data[,index]

#Naming variables in the data set
colnames(data)<-features[index,2]

#reading data to add activity classes in the data set
yTrainData <- read.table("train/y_train.txt", header=F, sep="")
yTestData <- read.table("test/y_test.txt", header=F, sep="")
ActivityData<-rbind(yTrainData,yTestData)

#Adding activity variable and names
ActivityNames<-read.table("activity_labels.txt", header=F, sep="")
data$activity<-factor(ActivityData$V1,labels=ActivityNames[,2])

#reading data to add subject data in the data set
subjectTrainData <- read.table("train/subject_train.txt", header=F, sep="")
subjectTestData <- read.table("test/subject_test.txt", header=F, sep="")

#Adding subject variable
SubjectData<-rbind(subjectTrainData,subjectTestData)
data$subject<-SubjectData$V1

#creating a new data set with the average of each variable for each activity and each subject
tidyData<-aggregate(data[,1:48], by=list(activity=data$activity,subject=data$subject), FUN=mean, na.rm=TRUE)


#exporting the tidy data frame
write.table(tidyData, file="tidyData.txt", sep=" ", row.names=FALSE)
