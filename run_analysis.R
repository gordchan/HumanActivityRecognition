## Part 0
## Loading libries

library(dplyr)
library(data.table)
library(reshape2)

## Reading the data sets

## Labels
labels <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", stringsAsFactors=FALSE)
## Test data set
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject") #Subject id
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt", col.names = "activity") #Activity index
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = labels[[2]]) #Main data set
## Train data set
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subject") #Subject id
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt", col.names = "activity") #Activity index
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = labels[[2]]) #Main data set

## Convert data table to data.table
X_test <- as.data.table(X_test)
X_train <- as.data.table(X_train)



## Part 1
## Combine 3 components into single data set
## Test data set
test <- cbind(subject_test, Y_test, X_test)
## Train data set
train <- cbind(subject_train, Y_train, X_train)

## Combine Test & Train data sets
data <- rbind(test, train)



## Part 2
## Look for index of columns on mean & SD
msd <- grep("(mean|std)", names(data), value = FALSE)
## Look for index of meanfreq() variables
mf <- grep("meanFreq", names(data), value = FALSE)
## Remove index for meanfreq()
msd <- msd[!msd %in% mf]
labels_msd <- labels[msd-2,] ## New selected labels for easy ref
names(labels_msd) <- c("index","label")
### To be revised, should name with desc names in Part 4.###
#labels_msd <- mutate(labels_msd, feature = sub("[[:punct:]]mean[[:punct:]][[:punct:]]", "", label))
#labels_msd <- mutate(labels_msd, feature = sub("[[:punct:]]std[[:punct:]][[:punct:]]", "", feature))

## Select columns
s_data <- data[c(1,2,msd)]



## Part 3
## Sort the activities before renaming
s_data <- arrange(s_data, subject, activity)

## Name the activities with descriptive activity names
for (j in 1:nrow(activity_labels)){
    s_data[2] <- with(s_data[2], replace(s_data[2], s_data[2]==activity_labels[j, 1], activity_labels[j, 2]))
}



## Part 4
## Rename variables with descriptiive variable names
## function to check time/freq domain
t_or_f <- function (x){
    ifelse(grepl("(^t)", x), "time_domain_", ifelse(grepl("(^f)", x), "function_domain_", ""))
}
## function to check body/gravity
b_or_g <- function (x){
    ifelse(grepl("(Body)", x), "body_", ifelse(grepl("(Gravity)", x), "gravity_", ""))
}
## function to check acceleration/gyroscopic
a_or_g <- function (x){
    ifelse(grepl("(Acc)", x), "acceleration_", ifelse(grepl("(Gyro)", x), "gyroscopic_", ""))
}
## function to check jerk
je <- function (x){
    ifelse(grepl("(Jerk)", x), "jerk_", "")
}
## function to check X/Y/Z axis
ax <- function (x){
    ifelse(grepl("([X$])", x), "x-axis_", ifelse(grepl("([Y$])", x), "y-axis_", ifelse(grepl("([Z$])", x), "z-axis_", "")))
}
## function to check jerk
ma <- function (x){
    ifelse(grepl("(Mag)", x), "_magnitude", "")
}
## function to generate descriptive variable names
gen_var <- function(x){
    v1 <- t_or_f(x)
    v2 <- b_or_g(x)
    v3 <- a_or_g(x)
    v4 <- je(x)
    v5 <- ax(x)
    v6 <- "signal"
    v7 <- ma(x)
    return(paste(v1,v2,v3,v4,v5,v6,v7, sep = ""))
}


## Creat naming elements
labels_msd <- mutate(labels_msd, t_f = t_or_f(label)) %>%
                mutate(b_g = b_or_g(label)) %>%
                mutate(a_g = a_or_g(label)) %>%
                mutate(j = je(label)) %>%
                mutate(a = ax(label)) %>%
                mutate(s = "signal") %>%
                mutate(m = ma(label)) %>%
                mutate(feature = gen_var(label))



## Part 5
## Create 2nd data set: avg of variables by activity & subject
## In wide format
wide_data <- suppressWarnings(aggregate(s_data, by=list(s_data$subject, s_data$activity), FUN="mean"))
wide_data <- select(wide_data, -(subject:activity))
names(wide_data)[1:2] <- c("subject","activity")

## In narrow format
narrow_data <- melt(wide_data, id.vars=c("subject","activity"))

### Add function column (To be revised, use indexed "labels_msd" to name column)###
narrow_data <- mutate(narrow_data, feature = gen_var(variable))

## function to check types as mean or std
mean_or_sd <- function(x) {
    ifelse(grepl("mean", x),"mean", ifelse(grepl("std", x),"std",NA))
}
## Add function type column
narrow_data <- mutate(narrow_data, type = mean_or_sd(variable))

## Seperate 
narrow_data <- select(narrow_data, subject, activity, feature, type, value) %>%
    dcast(subject + activity + feature ~ type, value.var="value")



## Part 6
## Output of the narrow data set in text format
write.table(narrow_data, "narrow_data.txt", row.name=FALSE)