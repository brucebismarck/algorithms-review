# INSTRUCTION: Edit this R file by adding your solution to the end of each 
# question. Upload the final file to Sakai.

# Your submitted file should run smoothly in R and provide all 
# required results. You are allowed to work with other students but the 
# homework should be in your own words. Identical solutions will receive a 0 
# in grade and will be investigated.

# This homework is an exercise in Least Squares computation.  We will
# build up R code that 1) computes a Q-R decomposition of a matrix X,
# 2) solves equations when the coefficients are upper triangular,
# 3) inverts an upper triangular matrix R, and finally
# 4) computes and returns most things we find useful in regression.
# We will be negligent in the sense that we will ignore precautions 
# that a numerical analyst would build into his code, and we will not
# consider measures to improve numerical conditioning such as pivoting
# (switching the order of the variables) either.


# BACKGROUND: Most LS solvers are based on decompositions of the
# design matrix of the form X = Q R, where R is square and triangular
# and Q has orthonormal columns.  The idea is that the LS criterion
# can be written as follows:
#      | y - X b |^2  =  | Q^T y - Q^T X b |^2  +  | r |^2
#                     =  | Q^T y - R b |^2      +  | r |^2
# where the first term can be forced to zero by solving  
#      Q^T y  =  R b
# This equation is easily solved when  R  is triangular.
# Furthermore, for inference we want the matrix (X^T X)^{-1},
# but with a Q-R decomposition this is easily gotten by
# inverting R because
#   (X^T X)^{-1}  =  R^{-1} R^{-1}^T


# PROBLEM 1: Write a function 'gs(X)' to implement the so-called
  # modified Gram-Schmidt procedure for orthnormalizing an nxp matrix.
  # This procedure consists of orthnormalizing the columns of X to form
  # the matrix Q of the same size, and storing the coefficients to
  # reconstitute X from Q in an upper triangular matrix R.

# Here is the algorithm:
#   Initialize Q with a copy of X
#   Loop over the columns of Q and do the following:
#     At stage j,
#       normalize Q[,j] in place
#       adjust the columns of Q[,(j+1):p] for Q[,j]
#       store the original length of Q[,j] in R[j,j]
#         and the coefficients from adjustment properly in row R[j,].
# If you do this right, it should hold that  X = Q R.
# Finish the function gs() with  return(list(Q=Q, R=R))

# In this algorithm, use loops and sum() to calculate inner products
# and sqrt() for lengths, but not lm() or any other high-level function.

# Test your function on these data:
#   X <- cbind(rep(1,10), 1:10, (1:10)^2)
#   sol <- gs(X)
# Show these and comment on them:
#   sol$Q %*% sol$R
#   t(sol$Q) %*% sol$Q
rm(list=ls())
# SOLUTION: 
X<-cbind(rep(1,10), 1:10, (1:10)^2)
gs <- function(X){
  Q <- X
  n <- dim(X)[1]
  p <- dim(X)[2]
  R <- matrix(0,nrow = p ,ncol = p)
  norm_vec <- function(x) sqrt(sum(x^2))
  #GS orthogonalization
  for (j in 1:p){
    miu <- rep(0,n)
    for (i in 1:(j-1)){
         if (j != 1){
           miu  <- miu  + (sum(X[,j]*Q[,i])/sum(Q[,i]^2))*Q[,i]
         }
    }
    Q[,j] <- X[,j] - miu
  }
  # normalization
  for (j in 1:p){
    Q[,j] <-  Q[,j]/norm_vec(Q[,j])
  }
  # get R
  R <- t(Q) %*% X
  
  return(list(Q=Q, R=R))
}

sol <- gs(X)
X
sol$Q %*% sol$R
t(sol$Q) %*% sol$Q

#----------------------------------------------------------------

# PROBLEM 2: Write function 'tri.solve(R,z)' that accepts an upper
# triangular matrix R and a colum z and returns the solution b of z =
# R b.  Show the results for these inputs:

#   z <- 10:1
#   R <- (row(diag(10)) <= col(diag(10)))

# You may use loops and the sum() function inside tri.solve() to spare
# yourself an inner loop, but you must not use canned solvers such as
# solve() or ginv() (the latter from the MASS package).

# SOLUTION:

tri.solve <- function(R,z){
  n <- dim(R)[1]
  b <- z[n]/R[n,n]
  for (i in (n-1):1){
    temp <-  (z[i] - sum(R[i,][(i+1):n] * b)) / R[i,i]
    b <- c(temp,b)
  }
  return(b)
}  
z <- 10:1
R <- (row(diag(10)) <= col(diag(10)))
tri.solve(R,z)
#----------------------------------------------------------------

# PROBLEM 3: No programming, just thinking.
# Assume R and R1 are upper triangular square matrices.
# Questions:
# a) If the vector b is has non-zero values only in the first k entries,
#    what can one say about z=Rb?
# b) When is R invertible?
# c) If the vector z has non-zero values only in the first k entries,
#    and if R is invertible, what can one say about the vector b?
# d) What can one say about R1%*%R?
# e) What can one say about R^{-1}?


# SOLUTION:
# (a) If the first k entires of b is non-zero, and the length of b is n,
#      that means first n-k entries of z are zero.
# b) Determinant of R is nonzero.
# c) B can have zero values only in last n-k entries.
# d) R1%*%R is still a upper triangular matrix.
# e) it is a upper triangular matrix.


#----------------------------------------------------------------

# PROBLEM 4: For inference about the regression coefficients, we need
# the matrix (X^T X)^{-1}.  In preparation for it, we need the
# inversion of an upper triangular matrix R because from a Q-R
# decomposition X=QR we can easily (X^T X)^{-1} if we have R^{-1}.
# Package the inversion in a function inv(R).  Try it out on the R
# matrix of the above 'sol':
#   inv(sol$R)
#   inv(sol$R) %*% sol$R
# Show both and comment on both.

# SOLUTION:

inv <- function(R){
  n <- dim(R)[1]
  inversemat<- rep(NA,n)
  for (i in 1:n){
    zero <- rep(0,n)
    zero[i] <- 1
    inverse <- tri.solve(R,zero)
    inversemat <- cbind(inversemat, inverse)
  }
  inversemat <- inversemat[,-1]
 return(inversemat) 
}

inv(sol$R)
inv(sol$R) %*% sol$R

#----------------------------------------------------------------

# PROBLEM 5: Using tri.solve(R,z), inv(R) and gs(X,y), write a
# function reg(X,y) that computes a list with the following named
# elements:

# a) "Coeffs": a matrix with one row per regression coefficient and columns
#    named "Coefficient", "Std.Err.Est", "t-Statistic", "P-Value"
# b) "Var": the coefficient variance matrix  s^2*(X^T X)^{-1}
# c) "RMSE": a number, s
# d) "R2": a number, R2
# e) "Residuals": the vector of residuals

# Assume that X does not have a column of 1's but an intercept is desired,
# hence first thing in the function do  X <- cbind(Icept=1,X) .

# You may use matrix multiplication if convenient, but no high-level
# functions other than things like sqrt() and pt().

# Try your solution on the following data and show the full result:
#   X <- cbind(Pred1=1:10, Pred2=(1:10)^2)
#   y <- rep(1,10) + 2*X[,1] + 3*X[,2] + resid(lm(rep(0:1,5)~X))
#   reg(X,y)
# Compare with results from the canned regression function
#   summary(lm(y~X))
# No need to comment, but you need to get the exact numbers.

# Compare the function execution time. Your function should be much faster.
#   system.time(for (i in 1:100){reg(X,y)})
#   system.time(for (i in 1:100){lm(y~X)})

# SOLUTION:

X <- cbind(Pred1=1:10, Pred2=(1:10)^2)
y <- rep(1,10) + 2*X[,1] + 3*X[,2] + resid(lm(rep(0:1,5)~X))

reg<- function(X,y){
  X <- cbind(rep(1,nrow(X)),X)
  n <- dim(X)[1]
  p <- dim(X)[2]
  sol<-gs(X)
  beta_hat <- inv(sol$R) %*% t(inv(sol$R)) %*% t(X) %*% y 
  RSS <- sum((y - X %*% beta_hat)^2)
  sigma_square <- RSS/(n-p)
  Residual <- y - X %*% beta_hat
  Residual_standard_error <- sqrt(sigma_square)
  Df <- n-p
  var <- sigma_square %*% diag(inv(sol$R) %*% t(inv(sol$R)))
  std_error<- sqrt(var)
  t <- as.vector(beta_hat) / std_error
  p_value <- 2*(1- pt(t,Df))
  SST <- sum((y - mean(y))^2)
  R_squared <- 1 - RSS/SST
  matrix <- cbind(as.vector(beta_hat),as.vector(std_error),as.vector(t),as.vector(p_value))
  colnames(matrix) <- c('Estimate','Std.Error','t value','Pr(>|t|)')
  return( list(Coeffs = matrix, RMSE = Residual_standard_error,
              R2 = R_squared, Residuals = Residual ))
}
reg(X,y)
summary(lm(y~X))
   system.time(for (i in 1:100){reg(X,y)})
   system.time(for (i in 1:100){lm(y~X)})
#----------------------------------------------
