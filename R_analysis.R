analysis <- function(folder="~/R data/Get_data_class/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset"){
    setwd(folder)
##Part 1, Generation of the merged dataset of interest

#Imports the list of features of the data set, to be used as column names
    features <- read.table('features.txt', as.is=TRUE)
    features <- features[,2]
#Creates is_para, a logical vector indicating the parameters kept in the tidy data set   
    is_mean <- grepl('mean()', features)
    is_meanF <- grepl('meanFreq()', features)
    is_std <- grepl('std()', features)
    is_para <- (is_mean & !is_meanF) | is_std

#Imports the training data set
    setwd("./train")
    train_data <- read.table('X_train.txt', col.names=features, colClasses = 'numeric', nrows = 7352)
#Subsets to keep only the data needed for the tidy data set
    train_data <- train_data[,is_para]
#Imports subject and activity associated with training data
    train_sub <- read.table('subject_train.txt', col.names="Subject", colClasses = 'numeric', nrows = 7352)
    train_act <- read.table('y_train.txt', col.names="Activity", colClasses = 'numeric', nrows = 7352)
#Creates a unique index for subject/activity
    train_index <- 6*train_sub + train_act
    names(train_index) <- 'Index'
    train_data <- cbind(train_index, train_sub, train_act, train_data)

#Performs the same operations on the test set
    setwd("../test")
    test_data <- read.table('X_test.txt', col.names=features, colClasses = 'numeric', nrows = 2947)
    test_data <- test_data[,is_para]
    test_sub <- read.table('subject_test.txt', col.names="Subject", colClasses = 'numeric', nrows = 2947)
    test_act <- read.table('y_test.txt', col.names="Activity", colClasses = 'numeric', nrows = 2947)
    test_index <- 6*test_sub + test_act
    names(test_index) <- 'Index'
    test_data <- cbind(test_index, test_sub, test_act, test_data)

#Joins the two data sets in a single 'data' variable
    data <- rbind(train_data, test_data)

##Part 2, Calculation of the mean of each value for a given subject/activity

#Function used to calculate the mean of each column of a data.frame after conversion to a numeric matrix
    meanmaker <- function(x){
        apply(data.matrix(x), MARGIN = 2, FUN = mean)
    }

#Splits the data by index
    list_data <- split(data, data[['Index']])
#Calculates a list containing the means of each column for each index, using the meanmaker function defined above
    list_means <- lapply(list_data, meanmaker)
    data_means <- do.call(rbind, list_means)

## Part 3, Removing unused variables, renaming and exporting tidy data set

#Removes index and row names
    data_means <- data_means[,-1]
    row.names(data_means) <- NULL

##Turns matrix into a data frame, replacing numbers by explicit names for activities
    data_means <- as.data.frame(data_means)
    setwd('..')
    activity <- as.character(read.table('activity_labels.txt')[[2]])
    data_means[,2] <- as.factor(data_means[,2])
    levels(data_means[,2]) <- activity

##Exports as a txt file, and returns the data frame to R console
    write.table(data_means, file='output.txt')
    data_means

}