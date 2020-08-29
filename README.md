# datasciencejhon
Assignment for "Getting and Cleaning data on R"course

The code takes the measurement files "X_train.txt" and "X_test", the activity tiles "y_train.txt" and "y_test.txt", the subject files "subject_test.txt" and "subject_train.txt" and the label files "features.txt" and "activity_labels.txt" and combines them in a dataframe (data). All these data has been taken from [1]. The variables (features) and activities are made tidy by eliminating capital leters and symbols A second dataset (data2) is made by aggregating the first one by activity and subject and calculating the average of the rest of the variables (features)
