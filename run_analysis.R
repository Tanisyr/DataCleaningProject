library("dplyr")

# This is the main data loading function. It loads both the test and training 
# datasets and concatentates them, returning a complete tidy dataset
#
loadAllData <- function() {
    featureCodes <- getFeatureCodes()
    activities <- loadActivities()
    train <- loadCompleteData(activities, featureCodes, train = TRUE)
    test <- loadCompleteData(activities, featureCodes, train = FALSE)
    data <- rbind(train, test)
    data
}

# Here is where the data is grouped by subject and activity and the mean of each
# feature taken
#
createSummaryDataset <- function() {
    data <- loadAllData()
    summary <- data %>% group_by(subject_id, activity) %>% 
        summarize_each(funs(mean)) %>%
        arrange(subject_id, activity)
    summary
}

# This function calculates the summary dataset and outputs it to the working 
# directory
#
outputSummary <- function() {
    summary <- createSummaryDataset()
    write.table(summary, file = "summary.txt", row.names = FALSE)
}

# Download the datafile if it exists and store it in the data directory
# NOTE: The data directory is in the .gitignore file due to the size of the files
#
downloadData <- function(destFile) {
    if(!file.exists("./data")) { dir.create("./data") }
    if(!file.exists(paste("./data/", destFile))) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileUrl, destFile = destFile)
    }
}

# Gets a particular file from the data archive and reads each line
#
getFile <- function(filename) {
    conn <- unz("./data/dataset.zip", filename = filename)
    lines <- readLines(conn)
    close(conn)
    lines
}

# Gets all feature codes that represent a mean or standard deviation and
# returns them in a data frame suitable for merging
# Columns are: code | feature
#
getFeatureCodes = function(filename) {
    codes <- getFile("UCI HAR Dataset/features.txt")
    codes <- strsplit(trimws(gsub("[ ]+"," ", codes)), " ")

    codes <- data.frame(codes, stringsAsFactors = FALSE)
    codes <- data.frame(t(codes))
    rownames(codes) <- c()
    colnames(codes) <- c("code", "feature")
    
    codes <- codes[grepl("mean()|std()", codes$feature), ]
    codes[] <- sapply(codes[], as.character)
    codes
}

# Loads the training or test dataset, cleaning the data of extra spaces
# and returning a dataframe with numeric column names from 1 to 561
#
loadDataset <- function(train = FALSE) {
    type <- ifelse(train, "train", "test")
    filename <- paste("UCI HAR Dataset/", type, "/X_", type, ".txt", sep = "")
    dataset <- list(getFile(filename))
    normalizeData <- function(row) {
        strsplit(trimws(gsub("[ ]+"," ", row)), " ")
    }
    dataset <- do.call(normalizeData, dataset)
    dataset <- lapply(dataset, FUN = as.numeric)
    dataset <- data.frame(dataset)
    dataset <- data.frame(t(dataset))
    rownames(dataset) <- c()
    colnames(dataset) <- 1:561
    dataset
}

# Loads the lookup table of activities
#
loadActivities <- function() {
    activities <- getFile("UCI HAR Dataset/activity_labels.txt")
    activities <- strsplit(trimws(gsub("[ ]+"," ", activities)), " ")
    
    activities <- data.frame(activities)
    activities <- data.frame(t(activities))
    rownames(activities) <- c()
    colnames(activities) <- c("activity_code", "activity")
    activities
}

# Returns the activity labels for either the test or training dataset
#
loadLabels <- function(activities, train = FALSE) {
    type <- ifelse(train, "train", "test")
    filename <- paste("UCI HAR Dataset/", type, "/y_", type, ".txt", sep = "")
    labels <- list(getFile(filename))
    labels <- data.frame(labels)
    colnames(labels) <- c("activity_code")
    labels <- dplyr::left_join(labels, activities, by = "activity_code")
    labels <- dplyr::select(labels, activity)
    labels
}

# Loads the subject identifiers for each window of data of either the test or 
# training dataset
#
loadSubjects <- function(train = FALSE) {
    type <- ifelse(train, "train", "test")
    filename <- paste("UCI HAR Dataset/", type, "/subject_", type, ".txt", sep = "")
    subjects <- lapply(list(getFile(filename)), as.numeric)
    subjects <- data.frame(subjects)
    colnames(subjects) <- c("subject_id")
    subjects
}

# This function uses the mean and standard deviation feature codes and selects
# just those columns from a raw dataset. It also labels the columns with their
# corresponding feature label
#
truncateJustMeanAndStd <- function(data, featureCodes) {
    dataset <- data[, featureCodes$code]
    colnames(dataset) <- featureCodes$feature
    dataset
}

# This function loads a complete test or training dataset along with its
# subject ids and activity labels and returns a tidy data frame with appropriate
# column names
#
loadCompleteData <- function(activities, featureCodes, train = FALSE) {
    dataset <- loadDataset(train)
    labels <- loadLabels(activities, train)
    subjects <- loadSubjects(train)
    dataset <- truncateJustMeanAndStd(dataset, featureCodes)
    data <- cbind(subjects, labels, dataset)
    data
}
