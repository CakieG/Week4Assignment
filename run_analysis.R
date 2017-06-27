##Import Data from WD
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("activity_labels.txt")


## Combines various tables provided in dataset 
combined_test <- cbind(subject_test, y_test, X_test)
combined_train <- cbind(subject_train, y_train, X_train)
combined_data <- rbind(combined_train, combined_test)

## Creates character vector out of imported features table, to be used for column naming
features <- features[2]
featurevector <- as.vector(features$V2)

##Create an intenger vector to identify and extract relevant colunns
mean_indices <- grep("-mean", featurevector, value = FALSE)
std_indices <- grep("-std", featurevector, value = FALSE)
wanted_columns <- c(mean_indices, std_indices)
wanted_columns <- sort(wanted_columns)
wanted_columns <- wanted_columns + 2
first2 <- c(1,2)
wanted_columns <- c(first2,wanted_columns)

##subset relevant columns from dataset
subset_columns <- combined_data[,wanted_columns]

##Add meaningful column names
first2names <- c("Subject", "Activity")
column_names <- c(first2names, featurevector)
column_names_subset <- column_names[wanted_columns]
colnames(subset_columns) <- column_names_subset

##Replace activity numbers with descriptive names
colnames(activities) <- c("Activity", "Act_Desc")
Replaced_Activities <- (merge(activities, subset_columns, by = "Activity"))
Replaced_Activities$Activity <- NULL

##Create new dataset with average for each subject and activity
melted_data <- melt(Replaced_Activities, c("Subject", "Act_Desc"))
casted_data <- dcast(melted_data, Subject + Act_Desc ~ variable)

casted_data