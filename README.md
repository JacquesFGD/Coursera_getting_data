Getting and cleaning data class, course project
===============================================

This repository contains a script (run_analysis.R) that first imports the training and test datasets and extracts the relevant parameters (part 1).
For each subject, and each eactivity, the script computes the mean of all values obtained for each parameter of interest (part 2, using the function meanmaker defined locally).
Finally the script returns a tidy data set containing this information (part 3, output as a txt file and directly in R)

The whole script is executed by using the command analysis(folder) after sourcing the R file, with folder being the address of the UCI HAR Dataset folder.
Since the tidy data set is also returned to the R console (in addition to an output.txt file), and assuming you are in the UCI HAR Dataset folder already it is advantageous to use :
**data <- analysis(getwd())**