library("caret", lib.loc="C:/R/R-3.1.0/library")
library("e1071", lib.loc="C:/R/R-3.1.0/library")
library("randomForest", lib.loc="C:/R/R-3.1.0/library")
#---------------------------------------------------------------------------------------------------------
tr_data<-read.csv(file="C:\\Users\\Nikolas\\Downloads\\pml-training.csv",header=TRUE,sep="," )
test_data<-read.csv(file="C:\\Users\\Nikolas\\Downloads\\pml-testing.csv",header=TRUE,sep="," )
summary(tr_data)
#featurePlot(x=tr_data,y=tr_data$class,plot="pairs")
#---------------------------------------------------------------------------------------------------------
set.seed(1234)
tr_ind <- createDataPartition(tr_data$classe, list = FALSE, p = 0.7)
tr_tr_data = tr_data[tr_ind, ]
ts_tr_data = tr_data[-tr_ind, ]
#---------------------------------------------------------------------------------------------------------
col_num = which(lapply(tr_tr_data, class) %in% c("numeric"))
preModel <- preProcess(tr_tr_data[,col_num], method = c("knnImpute"))
#preModel2 <- preProcess(predict(preModel, tr_tr_data[, col_num]), method = "pca")

ptr<- cbind(tr_tr_data$classe, predict(preModel, tr_tr_data[,col_num]))
ptest<- cbind(ts_tr_data$classe, predict(preModel, ts_tr_data[, col_num]))
ptest2<-predict(preModel, test_data[, col_num])

#ptraining <- cbind(tr_tr_data$classe, predict(preModel2,predict(preModel, tr_tr_data[, col_num])))
#ptesting <- cbind(ts_tr_data$classe, predict(preModel2,predict(preModel, ts_tr_data[, col_num] )))

names(ptr)[1] <- 'classe'
names(ptest)[1] <- 'classe'
names(ptest2)[1] <- 'classe'
#---------------------------------------------------------------------------------------------------------
model  <- randomForest(classe ~ ., ptr)

ptr_model<-predict(model,ptr)
print(confusionMatrix(ptr_model, ptr$classe))

ptest_model<-predict(model,ptest)
print(confusionMatrix(ptest_model, ptest$classe))

ptest2_model<-predict(model,ptest2)
print(confusionMatrix(ptest2_model, ptest2$classe))
