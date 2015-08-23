---
title: "README"
output: html_document
---
# Short Intro
Hello there!
This is a project for the Course Getting and Cleaning Data.
I tried to explain all steps in the code, here I provide simple codebook for all variables. As you can see from the names of the variables, I do not know all technical details very well, but I tried my best.

I am not native English speaker, so if you have recommendation how to effectively and fast learn English , I will very happy.

Any feedback (especially negative) is highly appreciated.

# How the data was produced
## Mining
First I write he function to extract data from folders. They differ only in name (test and train). What function do: it takes folder names, construct path with files name and read it to data frames. Result: we obtain two lists of data (train and test). I cannot transform them to dataframes, because almost all variables have different length.

## Join and subset the data
I use mapply function to bind variables from train and test data. 
I load labels from txt files and add them to list.
I subset the data, using regular expressions. It helps to preserve only rows with mean and standard deviation.

## Transform the data
I split the names to obtain the column with 'mean-sd' variable and then collect the names again. This variable helps to reshape data into tidy format.

# Codebook

Note, that sygnal is measured in three directions (for example, body acceleration signal (frequency domain signal) in X direction is coded as 'fBodyAcc X'). Magnitudes have no direction.



|Variable             |Description                                                             |
|:--------------------|:-----------------------------------------------------------------------|
|tGravityAcc          |Gravity acceleration signals (time domain signal)                       |
|fBodyGyro            |Gravity sygnal (time domain signal)                                     |
|tBodyAcc             |Body acceleration signal (time domain signal)                           |
|fBodyAccJerk         |Body Jerk signal (frequency domain signal)                              |
|tBodyAccJerk         |Body Jerk signal (time domain signal)                                   |
|tBodyGyroMag         |Magnitude of body acceleration signal (time domain signal)              |
|fBodyBodyGyroJerkMag |Magnitude of body Jerk signal (frequency domain signal)                 |
|fBodyAcc             |Body acceleration signal (frequency domain signal)                      |
|fBodyBodyAccJerkMag  |Magnitude of body (twice) gravity Jerk signal (frequency domain signal) |
|tBodyGyro            |Body gravity sygnal (time domain signal)                                |
|tBodyAccJerkMag      |Magnitude of body acceleration Jerk signal (time domain signal)         |
|tBodyGyroJerkMag     |Magnitude of body gravity Jerk signal (time domain signal)              |
|fBodyBodyGyroMag     |Magnitude of body (twice) gravity Jerk signal (frequency domain signal) |
|fBodyAccMag          |Magnitude of gravity acceleration signals (frequency domain signal)     |
|tBodyAccMag          |Magnitude of gravity acceleration signals (time domain signal)          |
|tBodyGyroJerk        |Magnitude of body (twice) Jerk signal (time domain signal)              |
|tGravityAccMag       |Magnitude of body gravity signal ((time domain signal)                  |

                   
