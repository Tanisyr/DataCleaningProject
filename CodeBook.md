# Code Book

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