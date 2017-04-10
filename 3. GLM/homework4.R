######### HOMEWORK 4, STOR 665: COMPUTING PART, DUE APR 10, 2017 #########

######### Student Name:    Wenyue Liu            #########

# INSTRUCTION: Edit this R file by adding your solution to the end of each 
# question. Your submitted file should run smoothly in R and provide all 
# required results. You are allowed to work with other students but the 
# homework should be in your own words. Identical solutions will receive a 0 
# in grade and will be investigated.

# This homework is an exercise in GLM estimation and inference.  We will
# build up R code that 1) implement the IRLS algorithm for Poisson 
# GLM and 2) use the algorithm to analyze a real dataset. 

# We will be negligent in the sense that we will ignore precautions
# that a numerical analyst would build into his code, and we
# will not consider measures to improve numerical conditioning such as 
# pivoting (switching the order of the variables) either.



#----------------------------------------------------------------

# PROBLEM 1: Write a function "my.poisson.glm(X,y)" to take X as a matrix
# and y as a vector of counts. The function then computes a 
# list with the following named elements:

# a) "Coeffs": a matrix with one row per regression coefficient and columns
#    named "Coefficient", "Std.Err.Est", "z-Statistic", "P-Value"
# b) "Residual Deviance": a number, D
# c) "Pearson Residuals": a vector of residuals
# d) "Deviance Residuals": a vector of residuals
# e) "Anscombe Residuals": a vector of residuals
# f) "Leverages": a vector of leverage values
# g) "Cook's Distance": a vector of Cook's distance

# You must use the IRLS algorithm in the function. The link function should be 
# log(). The only high-level function allowed is lm().

# SOLUTION: 
rm(list=ls())
				
my.poisson.glm <- function(X,y){     
   if (sum(y == 0) == 0){
        is0 <- 0
    }else
    {
        is0 <- 1
    }
  # initializing  
  y1 <- y + is0                  # if there is 0 in the prediction, add 1 to it. Since it is poisson, no reason to have -1
  lambda <- y1
  eta <- log(lambda)            # eta = theta = log(lambda) with log link function
  z <- eta + (y-lambda)/lambda  # z = g(yi) = g(lambda) + (yi-lambdai)g'(lambdai)
  w <- lambda                   # weight = b" (eta) = lambda
  dat <- as.data.frame(cbind(z,X))
  lmod = lm(z ~., weights = w, dat)
  last_coef <- coef(lmod)

  # finish initializing
  for(i in 1:1000){
    eta <- lmod$fit
    lambda <- exp(eta)						# g-inverse of eta to update mu
    z <- eta + (y-lambda)/lambda		# Updating the response
    w <- lambda						# Updating the weights
    dat=as.data.frame(cbind(z,X))
    lmod <- lm(z ~ ., weights=w, dat)	# Updating the estimate of beta
    #cat(i,coef(lmod),"\n")
    if (round(coef(lmod)[1],8) != round(last_coef[1],8) |round(coef(lmod)[2],8) != round(last_coef[2],8)){
           last_coef <- coef(lmod)
    }else{
      print(paste('Number of Fisher Scoring iterations:', toString(i)))
      break           # coefficient don't change much, break for loop
    }
  }
  Coeffs <- coef(lmod)
  beta <- unname(Coeffs)
  xm <- model.matrix(lmod)
  wm <- diag(w)
  SEE  <- unname(sqrt(diag(solve(t(xm) %*% wm %*% xm))))
  z_stat <- unname(Coeffs/SEE)
  p_val <- 2-2*pnorm(abs(z_stat)) 
  coef_mat <- as.data.frame(cbind(Coeffs,SEE,z_stat,p_val))
  
  y1=y
  for (i in 1:length(y)){
    if (y[i]==0) y1[i]=y1[i]+1;    # preventing NaN in residual calculation
  }
  D <- 2*sum(y*(log(y1)-log(lambda)) -y+lambda)
  
  R_residual <- y - lambda
  P_residual <- R_residual/sqrt(lambda)
  D_residual <- sign(R_residual)*sqrt(2*(y*(log(y1)-log(lambda)) -y+lambda))
  lambda1 <- ifelse(lambda > 1/6, lambda - 1/6, 0)
  A_residual <- (3/2 * (y^(2/3) - (lambda1)^(2/3)))/(lambda^(1/6))
  
  leverage <- diag(sqrt(wm)%*%xm%*%solve(t(xm) %*% wm %*% xm)%*%t(xm)%*%sqrt(wm))
  p <- 2   #?????? why p = 2 here 
  n <- nrow(as.matrix(X))
  dispersion <- 1  # not exactly as the notes, dispersion for possion = 1 
  cookd <-  (P_residual/(1 - leverage))^2 * leverage/(dispersion * 2)

  return( list(Coeffs = coef_mat, Residual_Deviance = D, Response_Residuals = R_residual,  Pearson_Residuals = P_residual,
               Deviance_Residuals = D_residual, Anscombe_Residuals = A_residual, 
               Leverages = leverage, CooksDistance = cookd ,fit=lambda ))
} 


#----------------------------------------------------------------

# PROBLEM 2: Description of the africa data. Start by loading the data:
library(faraway)					# Install this package if needed
data(africa)						# Load the africa data.
# Type "help(africa)" for details.
# Make a summary of data (average, max, min, etc for each variable).

# SOLUTION:
summary(africa)
#----------------------------------------------------------------

# PROBLEM 3: We study the association between the number of successful military coups
# and the number years country ruled by military oligarchy.
# We now fit the Poisson GLM "my.poisson.glm()" with the canonical link.
# We shall use "miltcoup" as the response and "oligarchy" as the predictor. 
# Make sure to include the intercept in the regression. Provide all the 
# output of the regression. Compare your output with that from R:
# 	modl <- glm(miltcoup~oligarchy,family=poisson(link = "log"),data=africa)
# 	summary(modl)

# SOLUTION:

X = africa[,2]; y=africa[,1]
myresult <- my.poisson.glm(X,y)
modl <- glm(miltcoup~oligarchy,family=poisson(link = "log"),data=africa)
std_result <- summary(modl)
myresult$Coeffs
std_result$coefficients
# looks good on coefficients

summary(myresult$Deviance_Residuals)
summary(std_result$deviance.resid)
#deviance residuals looks good

std_result$deviance
myresult$Residual_Deviance
# deviance looks good

# overall looks good!
#----------------------------------------------------------------

# PROBLEM 4: Study the model diagnostics of the model "modl".
# In particular, provide the following information and compare your output with
# that from R:
# a) The Pearson residuals and the Anscombe residuals from "modl"
# b) The residual vs. fitted plots for each of the four types of residuals. Make comments.
# c) The leverages vector. Which three countries have the highest leverage?
# d) The Cook's distance vector. Which three countries are most influential for the fit?
# e) The chi-square test based on deviance. Is there evidence of lack of fit?
# f) The Wald and profile likelihood confidence intervals for each coefficient.

# SOLUTION:
#a)
summary(resid(modl, type = 'pearson'))
summary(myresult$Pearson_Residuals)
library(wle)															
ra <- residualsAnscombe(y,mu=modl$fitted.values,family=poisson())
summary(ra)
summary(myresult$Anscombe_Residuals) # not equivalent

#b)
plot(myresult$fit, myresult$Response_Residuals, main = 'Plot of Response Residual vs. fitted value')
plot(myresult$fit, myresult$Pearson_Residuals, main = 'Plot of Pearson Residual vs. fitted value')
plot(myresult$fit, myresult$Deviance_Residuals, main = 'Plot of Deviance Residual vs. fitted value')
plot(myresult$fit, myresult$Anscombe_Residuals, main = 'Plot of Pearson Residual vs. fitted value')
#I think there is no obvious differences.

#c)
summary(influence(modl)$hat)
summary(myresult$Leverages)

#d)
summary(cooks.distance(modl))
summary(cookd)
sort(cooks.distance(modl), decreasing = T)[1:3]
# The three most influencial countries are Chat, Niger, Burkina Faso

#e)
chi_result <- 1-pchisq(myresult$Residual_Deviance,n-p-1)
print(chi_result)
# no evidence of a lack of fit

#f)
myresult$Coeffs

intercept_CI <- c(myresult$Coeffs[1,1] + 1.96 *  myresult$Coeffs[1,2], myresult$Coeffs[1,1] - 1.96 *  myresult$Coeffs[1,2])
beta1_CI <- c(myresult$Coeffs[2,1] + 1.96 *  myresult$Coeffs[2,2], myresult$Coeffs[2,1] - 1.96 *  myresult$Coeffs[2,2])

intercept_CI
beta1_CI
#----------------------------------------------------------------
