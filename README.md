# DataCleaningProject
## Getting and Cleaning Data Final Course Project

This is my repository for the Coursera Getting and Cleaning Data course final project.
  
The project entails processing summary data acquired from Samsung Galaxy S2 smartphones.
This analysis is performed in the script `run_analysis.R`. This script:

1. Downloads the UCI HAR dataset and stores it in the `/data` directory
2. Loads and cleans the data
3. Collects the various different pieces of the dataset together to form one
complete, tidy dataset
4. Calculates summary averages of each measurement
5. Outputs this summary dataset to `summary.txt` in the working directory

## Running the Script

The script can be sourced into R or R Studio, or it can be run from the command
line with `Rscript run_analysis.R`. This will create a `/data` directory with
the data .zip file, and a `summary.txt` file with the output of the analysis in
the working directory.