#It is assumed that the default working library is where the data is unzipped.

# Read activity labels
activities<-read.table("~/UCI HAR Dataset/features.txt", sep="", header=FALSE)
activities[,2]<-as.character(activities[,2])

# Activity features; default working directory ~ is used
features=read.csv("~/UCI HAR Dataset/features.txt", sep="", header=FALSE)
features[,2]<-as.character(features[,2])

# Activity labels
activity.labels <- read.table("~/UCI HAR Dataset/activity_labels.txt")
activity.labels[,2] <- as.character(activity.labels[,2])


# Get features that are either mean or standard deviation
indexes<-grep(".*mean.*|.*std.*|*Mean*|*Std*", features[,2])
features.needed<-features[indexes,2]
features.needed<-gsub('-mean', 'Mean', features.needed)
features.needed=gsub('-std','Std', features.needed)
features.needed=gsub('[-()]','', features.needed)

# Read training data; default working directory is used
training = read.table("~/UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)[indexes]
training.activities<-read.table("~/UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
training.subjects<- read.table("~/UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

# Column bind training data with subjects and activities data
training<-cbind(training.subjects,training.activities, training)

# Read test data; default working directory is used
testing = read.table("~/UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)[indexes]
testing.activities<- read.csv("~/UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testing.subjects<-read.csv("~/UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

# column bind the testing data
testing<-cbind(testing.subjects, testing.activities, testing)

# Merge the training and test datasets, and add column names
all.data<-rbind(testing, training)
colnames(all.data)<-c("subject", "activity",features.needed)


# turn activities & subjects into factors
all.data$activity <- factor(all.data$activity, levels = activity.labels[,1], labels = activity.labels[,2])
all.data$subject <- as.factor(all.data$subject)

# Gompute the mea for each variable for each activity and each subject
tidy.data = aggregate(all.data, by=list(activity = all.data$activity, subject=all.data$subject), mean)

# Remove columns with nulls resulting from aggregation
tidy.data[,4]<- NULL
tidy.data[,3]<- NULL

#write output to a tab separated text file
write.table(tidy.data, "tidy.txt", sep="\t", quote = FALSE)


