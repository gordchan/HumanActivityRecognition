# Codebook
Gordon CHAN  
16 Jul 2015  

## Project Description
This is a project to manipulate and tidy up part of the *Human Activity Recognition Using Smartphones Data Set* that is related to the mean and SD value of the variables.

##Study design and data processing

###Collection of the raw data
The original data are from the recordings of 30 subjects performing activities of daily living while carrying a waist-mounted smartphone with embedded inertial sensors.

###Notes on the original (raw) data 

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##Creating the tidy datafile

###Guide to create the tidy data file
The tidy file is created through the following steps:

1. Download the original dataset 
2. Load the following componenst of the dataset:
    - Lables for the features of the variables
    - Lables for the type of activities
    - For the Test and Train data sets:
        - Subject ID
        - Activity index
        - Main values dataset
3. Merge the three components of the Test and Train data sets
4. Merge the Test and Train data sets into a single data set
5. Select the Subject ID, Activity index, and columns related to mean and SD of the variables into a data frame
6. Clean the data as described by the next section

###Cleaning of the data
The data is cleaned throguh the following steps:

1. The data frame is sorted by the subject ID and then by the activity index
2. The activity index is replaced by the the actual activities
3. A wide format data frame is created by aggregating the mean for all the trials by each subject on each activity
4. The wide data frame is melted to form a narrow data frame
5. The variables are renamed according to the elements in the original name
6. Each variable is classified as the mean or SD of a measurement
7. The data frame is recasted to show the mean and SD of each measurement per entry(row)

The resulting data frame is tidy and clean:

a) Each column corresponds to a variable (each feature)
b) Each observation (mean and SD of each feature) is in a different row
c) There is a single data table

Sample from the data set:


```r
head(data)
```

```
##                                                                      
## 1 function (..., list = character(), package = NULL, lib.loc = NULL, 
## 2     verbose = getOption("verbose"), envir = .GlobalEnv)            
## 3 {                                                                  
## 4     fileExt <- function(x) {                                       
## 5         db <- grepl("\\\\.[^.]+\\\\.(gz|bz2|xz)$", x)              
## 6         ans <- sub(".*\\\\.", "", x)
```

```r
tail(data)
```

```
##                                                                          
## 160         if (!found)                                                  
## 161             warning(gettextf("data set %s not found", sQuote(name)), 
## 162                 domain = NA)                                         
## 163     }                                                                
## 164     invisible(names)                                                 
## 165 }
```

##Description of the variables in the narrow_data.txt file
General description of the file:


```r
 data <- read.table("narrow_data.txt", header=TRUE, stringsAsFactors=FALSE)
```

 - Dimensions of the dataset
 

```r
dim(data)
```

```
## [1] 5940    5
```

The dataset have 5 columns and 5940 rows.

 - Summary of the data
 

```r
 summary(data)
```

```
##     subject       activity           feature               mean         
##  Min.   : 1.0   Length:5940        Length:5940        Min.   :-0.99762  
##  1st Qu.: 8.0   Class :character   Class :character   1st Qu.:-0.93140  
##  Median :15.5   Mode  :character   Mode  :character   Median :-0.12974  
##  Mean   :15.5                                         Mean   :-0.30898  
##  3rd Qu.:23.0                                         3rd Qu.:-0.01192  
##  Max.   :30.0                                         Max.   : 0.97451  
##       std         
##  Min.   :-0.9977  
##  1st Qu.:-0.9714  
##  Median :-0.9194  
##  Mean   :-0.6597  
##  3rd Qu.:-0.3638  
##  Max.   : 0.6871
```
 
 - Variables present in the dataset
 

```r
names(data)
```

```
## [1] "subject"  "activity" "feature"  "mean"     "std"
```

###Variable 1: subject
*Subject ID* is unique identifier to the subjects.

 - Class of the variable: integer
 - Unique values/levels of the variable: 1 to 30
 - Unit of measurement: no unit

####Notes on variable 1:
The subjects are a group of 30 volunteers between 19-48 years of age.

###Variable 2 : activity
*Activity* is description to the activity performed by the subeject while wearing the smartphone at their waist.

 - Class of the variable: character
 - Unique values/levels of the variable:
 

```r
activity <- data.frame(unique(data$activity))
colnames(activity) <- "List of Activities"

print(activity)
```

```
##   List of Activities
## 1             LAYING
## 2            SITTING
## 3           STANDING
## 4            WALKING
## 5 WALKING_DOWNSTAIRS
## 6   WALKING_UPSTAIRS
```

 - Unit of measurement: no unit

###Variable 3 : feature
*feature* is description of the processed signals from the accelerometer and the gyroscope of the smartphone.

 - Class of the variable: character
 - Unique values/levels of the variable:
 

```r
feature <- data.frame(unique(data$feature))
colnames(feature) <- "List of Features"

print(feature)
```

```
##                                           List of Features
## 1  function_domain_body_acceleration_jerk_signal_magnitude
## 2     function_domain_body_acceleration_jerk_x-axis_signal
## 3     function_domain_body_acceleration_jerk_y-axis_signal
## 4     function_domain_body_acceleration_jerk_z-axis_signal
## 5       function_domain_body_acceleration_signal_magnitude
## 6          function_domain_body_acceleration_x-axis_signal
## 7          function_domain_body_acceleration_y-axis_signal
## 8          function_domain_body_acceleration_z-axis_signal
## 9    function_domain_body_gyroscopic_jerk_signal_magnitude
## 10        function_domain_body_gyroscopic_signal_magnitude
## 11           function_domain_body_gyroscopic_x-axis_signal
## 12           function_domain_body_gyroscopic_y-axis_signal
## 13           function_domain_body_gyroscopic_z-axis_signal
## 14     time_domain_body_acceleration_jerk_signal_magnitude
## 15        time_domain_body_acceleration_jerk_x-axis_signal
## 16        time_domain_body_acceleration_jerk_y-axis_signal
## 17        time_domain_body_acceleration_jerk_z-axis_signal
## 18          time_domain_body_acceleration_signal_magnitude
## 19             time_domain_body_acceleration_x-axis_signal
## 20             time_domain_body_acceleration_y-axis_signal
## 21             time_domain_body_acceleration_z-axis_signal
## 22       time_domain_body_gyroscopic_jerk_signal_magnitude
## 23          time_domain_body_gyroscopic_jerk_x-axis_signal
## 24          time_domain_body_gyroscopic_jerk_y-axis_signal
## 25          time_domain_body_gyroscopic_jerk_z-axis_signal
## 26            time_domain_body_gyroscopic_signal_magnitude
## 27               time_domain_body_gyroscopic_x-axis_signal
## 28               time_domain_body_gyroscopic_y-axis_signal
## 29               time_domain_body_gyroscopic_z-axis_signal
## 30       time_domain_gravity_acceleration_signal_magnitude
## 31          time_domain_gravity_acceleration_x-axis_signal
## 32          time_domain_gravity_acceleration_y-axis_signal
## 33          time_domain_gravity_acceleration_z-axis_signal
```

 - Unit of measurement: no unit
 - Schema used to constructed the entries:
 
The names are construted through a custom function which look for naming elements from the orignal variable name:

Sequence | Element from orinal name | Elements used in new name
-------- | ------------------------ | -------------------------
1        | *t* or *f*               | *time domain* or *function domain*
2        | *body* or *gravity*      | *body* or *gravity*
3        | *Acc* or *Gyro*          | *Acceleration* or *Gyroscopic*
4        | *Jerk* or nil            | *Jerk* or nil
5        | *X* or *Y* or *Z*        | *x-axis* or *y-axis* or *z-axis*
6        | for all variables        | *signal*
7        | *Mag*                    | *magnitude*

###Variable 4 : mean
*mean* is the mean of the mean measurement obtained from all of the trials.
 
 - Class of the variable: numeric
 - Unit of measurement: no unit

###Variable 5 : std
*std* is the mean of the standard deviation measurement obtained from all of the trials

 - Class of the variable: numeric
 - Unit of measurement: no unit

##Sources
Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

Description of the dataset can be found from:
https://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Dataset can be downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
