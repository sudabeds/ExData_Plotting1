---
title: "README"
author: "Sudabe"
date: "December 27, 2015"
output: html_document
---
---
title: "README"
author: "Sudabe"
date: "December 27, 2015"
output: html_document
---
Important: Before starting to explain I have to say that for some reasons Markdown has a problem with "stringr" package that I am using in this project. For this reason I need to deactivate some parts of the code in the following README file.
This script downloads the file from the website and save it in a folder called "Samsung.zip" in the current working directory of your computer. Then it uses "unzip" function and stores the data in a variable called "ProjData". ProjData is a character vector containing the addresses of all the 28 datasets in the original zip file. This way we can use addresses with read.table function to read different files that we need. Then the Samsung file will be deleted.

```{r}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "./Samsung.zip")
ProjData <- unzip("./Samsung.zip")
unlink("./Samsung.zip")
```

Then we need to install a package called "stringr" because later in the program we need to use this package to find the mean and std columns. It also installs "dplyr" just in case it is not already installed.

```{r}
#install.packages("stringr")
#library(stringr)
#install.packages("dplyr")
#library(dplyr)
```

I did not use the data in "Inertial Signals" folders I just used: Subject_test, X_test and Y_test datasets.These are available in test and train folders.First I use cbind to put the columns of these files together. After I did it for both "test" and "train groups" separately and named them "test_set" and "train_set" respectively I stack these files on top of each other by using rbind and I named it "train_test".

```{r}
subj_test=read.table("./UCI HAR Dataset/test/subject_test.txt")
X_test=read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test=read.table("./UCI HAR Dataset/test/Y_test.txt")

subj_train=read.table("./UCI HAR Dataset/train/subject_train.txt")
X_train=read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train=read.table("./UCI HAR Dataset/train/Y_train.txt")

test_set=cbind(subj_test, Y_test, X_test)
train_set=cbind(subj_train, Y_train, X_train)
train_test=rbind(test_set,train_set)
```

I used "features" dataset to lable the columns of the "train_test" for part 4 of the project. So in "train_test" the first column is the subjects' numbers the second one is the activity code (called "Test lable!" I think activity code is a better option) and the rest of the columns are the measurement lists that we obtain their lables from "features " dataset.

To find the mean and std columns I used "str_match" which is a function in "stringr" package.  This function looks at each name in the feature dataset and check if it has "mean" or "std" in it if yes it yields the value that is matched if not it gives NA. Therefore I made three columns in feature dataset as follow:

* mean_col: if the row contains the "mean" value it is  "mean" otherwise it is NA

* meanFreq_col: if the row contains "meanFreq" value it is "meanFreq" otherwise it is NA

* std_col: if the row contains "std" value it is "std" otherwise it is NA

```{r}
# features=read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = F)
# colnames(train_test)=c("Subject", "Test Labels", features$V2 )
# features$mean=str_match(features$V2, "mean")
# features$meanFreq=str_match(features$V2, "meanFreq")
# features$std=str_match(features$V2, "std")
# mean_col=which(!is.na(features$mean))+2
# meanFreq_col=which(!is.na(features$meanFreq))+2
# mean_col=mean_col[!(mean_col %in% meanFreq_col)]
# std_col=which(!is.na(features$std))+2
# mean_std_col=c(mean_col,std_col)

```


By using thesevectors as columns of "features" dataset I can check if str_match is doing a good job.
You may ask:

* Why we need meanFreq_col? Unfortunately this str_match function is not sensitive enough to just choose mean() and not meanFreq. Therefor I first find all mean columns (including mean() and meanFreq) and then omit meanFreq from actual means (mean()) using the following command.

```{r}
# mean_col=mean_col[!(mean_col %in% meanFreq_col)]

```

* Why I do not search for both std and mean at the same time and I do it separately? Again this str_match gets confused and make some mistakes. The best is to do it one by one.

After finding the row numbers containing mean and std values in feature dataset I have to add them by 2, becase in "train_test" dataset the first two columns are not part of features. Therefore for example rows (1,2 and 3)in "features" are columns' (3,4 and 5) labels in "train_test" dataset.
After all these the dataset that just contains mean and std is called "data_mean_std" and it contains 68 different variables.

```{r}
# mean_std_col=sort(mean_std_col)
# data_mean_std=train_test[,c(1,2,mean_std_col)]

```
We have 6 different activity codes in column 2. To clarify and label them I use a "for" loop.

```{r}
# y=data_mean_std$`Test Labels`

# for(i in 1:nrow(train_test)){
#if(y[i]==1)
  # {data_mean_std[i,2]="WALKING"}
  # else if(y[i]==2){data_mean_std[i,2]="WALKING_UPSTAIRS"}
  # else if(y[i]==3){data_mean_std[i,2]="WALKING_DOWNSTAIRS"}
  # else  if(y[i]==4){data_mean_std[i,2]="SITTING"}
  # else if(y[i]==5){data_mean_std[i,2]="STANDING"}
  # else {data_mean_std[i,2]="LAYING"}
#}
```
At the end I split the data by two factors of "subject" and "activity". And then I used "sapply" function to find average of each measurement for each activity and each subject. At the end final_data that I submitted is the transpose of what we got from previous step (sapply).

```{r}
# fact=data_mean_std[,2:1]
# data_mean_std_split=split(data_mean_std,fact)
# data_mean_std_5=sapply(data_mean_std_split,function(x){colMeans(x[,3:ncol(data_mean_std)])})
# final_data=t(data_mean_std_5)
# View(final_data)

```
Checking if data is tidy:
I checked the data to make sure that it is tidy and It meets the following criteria for a tidy dataset according to Hadley Wickham (http://vita.had.co.nz/papers/tidy-data.pdf):

*	Each variable forms a column: Columns are unique for the "final_data" dataset. I checked it with "duplicate" function.

* Each observation forms a row.  There are 180 rows which contains all 6 activities for each subject (6*30=180). Rows are also unique.

* Each type of observational unit forms a table.

I hope I was clear enough. Thank you very much for your time and Good luck with your studying!




