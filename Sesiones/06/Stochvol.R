# Universidad Nacional de Ingenieria
# R Aplicado
# Jose Guerra
# 2025

install.packages("stochvol")

rm(list=ls())

library("stochvol")
set.seed(42)

data("exrates")

ind <- which(exrates$date >= as.Date("2008-03-01") &
               exrates$date <= as.Date("2012-03-01"))
CHF_price <- exrates$CHF[ind]

res_sv <- svsample(CHF_price, designmatrix = "ar1")
res_sv

CHF_logret <- 100 * logret(CHF_price)
res_svt <- svtsample(CHF_logret, designmatrix = "ar0") # t-errors
res_svt



