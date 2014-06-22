Human Activity Recognition in Weigtht Lifting for Coursera Practical Machine Learning Course
============================================================================================

## Introduction

  The course project is about the recognition of human activity. Six participants were asked perform barbell lifts in five differnt ways (A,B,C,D,E) with sensors attached on them. The goal is to identify the way they performed the exercise from the data collected.
  
## Libraries used

For the project we will have to load these three libraries:

```r
library("caret")
library("e1071")
library("randomForest")
```

## Data manipulation

Datasets retrieval:

```r
tr_data<-read.csv(file="pml-training.csv",header=TRUE,sep="," )
test_data<-read.csv(file="pml-testing.csv",header=TRUE,sep="," )
```

For cross validation purposes, training data will be further sliced, 70% training dataset and 30% test dataset:

```r
set.seed(1111)
tr_ind <- createDataPartition(tr_data$classe, list = FALSE, p = 0.7)
tr_tr_data = tr_data[tr_ind, ]
ts_tr_data = tr_data[-tr_ind, ]
```
Numeric columns seperation:

```r
col_num = which(lapply(tr_tr_data, class) %in% c("numeric"))
```

The next step is to do some basic preprocessing by standardizing datasets and renaming some columns:

```r
preModel <- preProcess(tr_tr_data[,col_num], method = c("knnImpute"))
ptr<- cbind(tr_tr_data$classe, predict(preModel, tr_tr_data[,col_num]))
ptest<- cbind(ts_tr_data$classe, predict(preModel, ts_tr_data[, col_num]))
ptest2<-predict(preModel, test_data[, col_num])

names(ptr)[1] <- 'classe'
names(ptest)[1] <- 'classe'
names(ptest2)[1] <- 'classe'
```

## Model

We will use "random forests" algorithm to builde the model:

```r
model  <- randomForest(classe ~ ., ptr)
#model<-train(classe~.,data=ptr,method="rf",prox=TRUE) not enough RAM
```

Confusion Matrix on training data shows accuracy 100%:

```r
training_pred <- predict(rf_model, ptraining) 
print(confusionMatrix(training_pred, ptraining$classe))
```

Confusion Matrix on testing data shows accuracy 98.57%, so we don't need to prune the model:

```r
ptest_model<-predict(model,ptest)
print(confusionMatrix(ptest_model, ptest$classe))
```

## Results

The final step is to use the 20 test cases given (pml-testing.csv) to predict the way they perform the exercise: 

```r
results <- predict(rf_model, prtesting) 
results
```
The results are:

|1  |2  |3  |4  |5  |6  |7  |8  |9  |10 |11 |12 |13 |14 |15 |16 |17 |18 |19 |20 | 
|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|--:|
|B  |A  |B  |A  |A  |E  |D  |B  |A  |A  |B  |C  |B  |A  |E  |E  |A  |B  |B  |B  |








