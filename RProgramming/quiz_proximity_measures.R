library(e1071)


# Question 3 Compute the Hamming distance between the two records defined over 5 binary attributes:
x <- c(1, 0, 0, 1, 1)
y <- c(0, 0, 1, 0, 1)

hamming.distance(x, y)
z <- rbind(x,y)

hamming.distance(z)

#Question 6 Given two records rec1 and rec2 defined over 6 binary attributes 

rec1 <- c(0, 1, 0, 0, 1, 0)
rec2 <- c(1, 1, 0, 1, 0, 0)

#Compute the Simple Matching Coefficient (SMC) and the Jaccard Coefficient (JC) 
#between the two records.

#SMC
smc <- function(v1=data, v2=data) {
  
  sum(rec1==rec2)/length(rec1)
  
}

smc(rec1,rec2)

#jaccard
jaccard <- function(v1=data, v2=data) {
  
  sum((v1==1)&(v2==1))/sum((v1==1)|(v2==1))
  
}

jaccard(rec1,rec2)


