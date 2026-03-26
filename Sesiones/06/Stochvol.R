# Universidad Nacional de Ingenieria
# Pre-Maestria
# R Aplicado
# Jose Guerra
# Marzo 2026

rm(list=ls())

### MS GARCH ###
library(quantmod)

data <- getSymbols('NVDA', src="yahoo", auto.assign=FALSE)
data

returns <- diff(log(data$NVDA.Adjusted))
returns <- returns[!is.na(returns)]

install.packages("MSGARCH")
library(MSGARCH)

?CreateSpec
spec <- CreateSpec(variance.spec = list(model = c("sGARCH", "sGARCH")), 
                   distribution.spec = list(distribution = c("norm", "norm")))

?FitML
garch2 <- FitML(spec=spec, data=returns)

class(garch2)
# GARCH(1,1) state 1:
#  - alpha0_1
#  - alpha1_1
#  - beta_1
# GARCH(1,1) state 2:
#  - alpha0_2
#  - alpha1_2
#  - beta_2
print(garch2)


?CreateSpec
spec <- CreateSpec(variance.spec = list(model = c("sGARCH", "sGARCH")), 
                   distribution.spec = list(distribution = c("norm", "norm")))

?FitML
garch2 <- FitML(spec=spec, data=returns)



### stochvol ###

rm(list=ls())

install.packages("stochvol")
library("stochvol")
set.seed(42)

data("exrates")

ind <- which(exrates$date >= as.Date("2008-03-01") &
               exrates$date <= as.Date("2012-03-01"))
CHF_price <- exrates$CHF[ind]

plot(CHF_price, type='l')

?svsample
res_sv <- svsample(CHF_price, designmatrix = "ar1")
res_sv
summary(res_sv)
plot(res_sv)
volplot(res_sv)

CHF_logret <- 100 * logret(CHF_price)
res_svt <- svtsample(CHF_logret, designmatrix = "ar0") # t-errors
res_svt
plot(res_svt)


# NVDA
vol_NVDA <- svtsample(returns, designmatrix = "ar0")
vol_NVDA
plot(vol_NVDA)

