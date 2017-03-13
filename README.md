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

## Data Acquisition and Processing

1. The Galaxy S2 data is downloaded and stored in the `/data` directory. This directory
has been added to the `.gitignore` so as to prevent unnecessary remote storage.
2. The features and activities lookup tables are loaded.
3. Each dataset is read in and cleaned (see cleaning section below)
4. The subject and activity labels for the dataset are loaded
5. The cleaned dataset has all non-mean, non-standard-deviation columns removed
6. The subject labels, activity labels, and dataset are bound together to create
a single complete, tidy dataset
7. The separate test and training datasets are appended to one another
8. Summary data is calculated by grouping on subject id and activity
9. This summary dataset is output to `summary.txt` in the working directory

## Cleaning

The primary data files containing the window data, although whitespace separated,
were not uniformly separated. These files were processed by removing leading and
trailing whitespace, and then replacing any occurrences of multiple spaces with
single ones. This allowed the R `strsplit` function to easily convert the data
rows into vectors for processing.
  
The activities and features lookup tables were similarly filtered for good measure.
  
The subjects and labels files required no cleaning.

