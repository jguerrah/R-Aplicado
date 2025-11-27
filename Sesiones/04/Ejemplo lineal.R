# Universidad Nacional de Ingeniería
# R
# Jose Guerra
# Noviembre 2025

# rm(list = ls())

# Fuente: http://cameron.econ.ucdavis.edu/aed/index.html
# A. Colin Cameron
# Parte I: Analysis of a Single Series

########## SETUP ##########
install.packages("haven") # read DTA

########## DATA DESCRIPTION

# House sale price for 29 houses in Central Davis in 1999
#     29 observations on 9 variables
library(haven)
direccion <- 'http://cameron.econ.ucdavis.edu/aed/AED_HOUSE.DTA'
data.HOUSE <- read_dta(direccion)

#attach(data.HOUSE)
#detach(data.HOUSE)

summary(data.HOUSE)

# Modelo MCO
ols <- lm(price ~ size, data.HOUSE)
ols

summary(ols)

# Figure 1.1
plot(data.HOUSE$size,data.HOUSE$price,
     xlab="House size in square feet",
     ylab="House sale price in dollars",
     pch=19)
abline(ols)
legend(2700, 270000, c("Actual",  "Fitted"),
       lty=c(-1,1), pch=c(19,-1), bty="o")

library(ggplot2)
ggplot(data.HOUSE, aes(x=size, y=price)) +
  geom_point() +
  stat_smooth(method='lm', color='red')

# Way to directly write Figure 1.1 to file
png("figura1.png")
plot(data.HOUSE$size,data.HOUSE$price,
     xlab="House size in square feet",
     ylab="House sale price in dollars",
     pch=19)
abline(ols)
legend(2900, 270000, c("Actual","Fitted"),
       lty=c(-1,1), pch=c(19,-1), bty="o")
dev.off()


# Parte I: Analysis of Several Series

rm(list=ls())

# Install any packages used
install.packages("sandwich") # For robust standard errors
install.packages("jtools") # For nicer regression output 
install.packages("huxtable") # For tables of regression output

############# DATA DESCRIPTION
direccion <- 'http://cameron.econ.ucdavis.edu/aed/AED_HOUSE.DTA'
data.HOUSE <- read.dta(direccion)

# Table 10.1
table101vars = c("price", "size", "bedrooms", "bathrooms", "lotsize",
                 "age", "monthsold")
summary(data.HOUSE[table101vars])

# Table 10.2
data.HOUSE
summary(data.HOUSE)


#price = c0 + c1*bedrooms + error
ols.onereg = lm(price ~ bedrooms, data.HOUSE)
summary(ols.onereg)

#price = c0 + c1*bedrooms + c2*size + error
ols.tworeg = lm(price ~ bedrooms + size, data.HOUSE)
summary(ols.tworeg)

####  10.2 TWO-WAY SCATTERPLOTS

# Figure 10.1
pairs(~price+size+bedrooms+age, data=data.HOUSE,
      main="Simple Scatterplot Matrix")

install.packages('GGally')
library(GGally)

ggpairs(data.HOUSE)


####  10.3 CORRELATION

# Table 10.3
cor(data.HOUSE[-8])

cols = c("price","size","bedrooms","bathrooms",
         "lotsize","age","monthsold")
cor(data.HOUSE[cols])


####  10.4 REGRESSION LINE

# Multivariate regression
ols.full = lm(price ~ size+bedrooms+bathrooms+lotsize+age+monthsold,
              data=data.HOUSE)
summary(ols.full)

# Nicer output
library(jtools)
summ(ols.full, digits=3)
summ(ols.full, digits=3, confint='TRUE')

# Demonstrate that can get from bivariate regression on a residual
ols.size = lm(size ~ bedrooms+bathrooms+lotsize+age+monthsold,
              data=data.HOUSE)
resid.size = resid(ols.size)
# resid.size = size - (c1*bedrooms+c2*bathrroms+...)
ols.biv = lm(price ~ resid.size,data=data.HOUSE)
summary(ols.biv)

####  10.6 MODEL FIT
# R-squared is squared correlation between yhat and y
sum.full = summary(ols.full)
sum.full$r.squared
pprice = predict(ols.full)
summary(cbind(data.HOUSE$price,pprice))
cor = cor(cbind(data.HOUSE$price,pprice))[2,1]
cor^2

ggplot(mapping=aes(x=pprice, y=data.HOUSE$price)) +
  geom_point()


# Compute adjusted R-squared
# $nobs is N, $ncoeff is k, $df is N-k 
# Adjusted R-squared 
k = sum.full$df[1]
df = sum.full$df[2]
r2 = sum.full$r.squared
r2adj = r2 - ((k-1)/df)*(1-r2)
r2adj
sum.full$adj.r.squared

# Compute AIC and BIC manually
N = df + k
resSS = df*sum.full$sigma^2
# AIC as computed by many packages including Stata
aic = N*log(resSS/N) + N*(1+log(2*3.1415927)) + 2*k
aic
# AIC as computed by R drops the second term
aic_R = N*log(resSS/N) + 2*k
aic_R
extractAIC(ols.full)   # From summary(lm) output
# BIC as computed by many packages including Stata
bic = N*log(resSS/N) + N*(1+log(2*3.1415927)) + k*log(N)
bic
