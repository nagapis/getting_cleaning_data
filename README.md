# Getting & Cleaning Data
## Course Project Readme

This readme.md document details the working of the run_analysis.R script that is submitted by me for the course project.
The prupose of the script is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. 

The script is dependant on 2 R packages - tidyr and dplyr.
The script begins by loading these.  It then programatically downloads the data zip file to a specific location on my machine, unzips the data and reads the text files in the zip fie using the *read.table* command.

Once this is done, the *activity* and *subject* columns are relabelled from "V1" to "Activity" and "Subject".
I then bind the *train* and *test* datasets for both X and Y (where x is the table of observations and y is the activity vector).

I also perform a similar combination (*using rbind, just as before*) for the subject vector, but this time creating a long subject vector as a factor.  The activity factor is automatically created.

The feature data contains the column names for the observation table (x).  This is read in and assigned to the column names using the *colnames* function.  During this process, I force each column name to be unique, which also changes any unusual charachters to periods.

The next step is to combine all data using *cbind*, such that the long activity vector, the long subject vector and the observation table are all binded.

Now, using the *dplyr* package (specifically the *select* command), I take the subset of columns that contain a wildcard name of either "mean" or "std", as we're only interested in the means or standard deviations of the observations.
At this stage, I also remvove any "meanFreq" columns as they are not of interest.

I now tidy the variable names by removing all periods from the names as well as changing the capitalisation and abbreviation for 'mean' and 'standard deviation'.

I then use the *group_by* and *summarise_each* commands in the *dplyr* package to group the data by the two factors (subject and activity) and then aggregate the means of the observations.

Finally, I write the output table to a txt file using *write.table*.

