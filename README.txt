How to run code for the Using Naïve Bayes to predict income levels from the Costa Rica Household Poverty Survey

Authors: Courtney Irwin (Matthew Stewart contributed to this project using Random Forrest as a comparator method.  The Naive Bayes code here is my own.)

MATLAB Version:MATLAB2018b

Required Files are:
 - cleandata.m : a function to clean the data
 - grid_search_nbv5.m : the main file for running the naive bayes algorthim
 - macrof1.m: a function to calculate the macrof1 from a confusion matrix
 - train.csv: the full dataset from the model; 
		downloaded from https://www.kaggle.com/c/costa-rican-household-poverty-prediction/data

To run the code and reproduce the results, run (only) the following files in MATLAB2018b:
- grid_search_nbv5.m : the main file for running the naive bayes algorthim

The other function files will be called from within these files.



