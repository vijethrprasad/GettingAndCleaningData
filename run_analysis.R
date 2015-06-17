## Below R script called run_analysis.R does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


##Loading required packages
library(data.table)
library(reshape2)
library(dplyr)

# Reads activity labels into act_labs
act_labs <- read.table("./activity_labels.txt")[,2]

# Reads data column names from features.txt
feat <- read.table("./features.txt")[,2]

# Extracts only the measurements on the mean and standard deviation for each measurement.
xtrct_feat <- grepl("mean|std", feat)

# Reads X_test & y_test data.
x_tst <- read.table("./test/X_test.txt")
y_tst <- read.table("./test/y_test.txt")
sub_tst <- read.table("./test/subject_test.txt")

names(x_tst) = feat  ## Naming columns

# Extract only the measurements on the mean and standard deviation for each measurement.
x_tst = x_tst[,xtrct_feat]

# Read activity labels
y_tst[,2] = act_labs[y_tst[,1]]
names(y_tst) = c("Activity_ID", "Activity_Label")   ## Naming Columns
names(sub_tst) = "subject"

# Binding test data
tst_data <- cbind(as.data.table(sub_tst), y_tst, x_tst)

# Reads x_train & y_train data.
x_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")

sub_train <- read.table("./train/subject_train.txt")

names(x_train) = feat

# Extract only the measurements on the mean and standard deviation for each measurement.
x_train = x_train[,xtrct_feat]

# Get activity data
y_train[,2] = act_labs[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")  ## Namings Columns
names(sub_train) = "subject"

# Binding Train data
train_data <- cbind(as.data.table(sub_train), y_train, x_train)

# Merging test and train data using rbind
mdata = rbind(test_data, train_data)

id_labs   = c("subject", "Activity_ID", "Activity_Label")
data_labs = setdiff(colnames(mdata), id_labels)
melt_data      = melt(mdata, id = id_labs, measure.vars = data_labs)  ## Convert data into Data Frame

# Applying mean function to dataset using dcast function
tdata   = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(tdata, file = "./tdata.txt", row.names = FALSE)  ## Writing tiday dat into text file