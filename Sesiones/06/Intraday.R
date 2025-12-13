
install.packages("quantmod")
library(quantmod)

ticker <- "FRMI" # Fermi Inc.
period <- "60min" # 30min, 15min, etc.

?getSymbols
data <- getSymbols(ticker, src = "yahoo", 
                   periodicity = period, auto.assign = FALSE)
data

?chartSeries
chartSeries(data, theme = chartTheme("white"), 
            name = "Intraday (60 min)")

chartSeries(data, subset = "last 5 days",
            theme = chartTheme("white"), name = "Intraday (60 min)")

chartSeries(data, type="line", subset = "last 5 days",
            name = "Intraday (60 min)")

library(dplyr)
library(ggplot2)

data <- data.frame(Date = index(data), coredata(data))
data

ggplot(data, aes(x = Date, y = FRMI.Close)) +
  geom_line() +
  labs(title = "FRMI Adjusted Close (60 min)", x = "Time", y = "Price")


install.packages("rugarch")
library(rugarch)

?ugarchspec
# E[(x-E[x])^2]
# E[x] = mean.model

returns <- diff(log(data$FRMI.Close))

# Vol: GARCH(1,1) - Mean model: Const
spec <- ugarchspec(variance.model = list(model="sGARCH", garchOrder=c(1, 1)), 
                   mean.model = list(armaOrder=c(0,0), include.mean=TRUE), 
                   distribution.model = "norm")

?ugarchfit
garch11 <- ugarchfit(spec=spec, data=returns)

class(garch11)
print(garch11)
# omega: constante
# alpha1: coef del error
# beta1: coef del sigma

plot(garch11)

plot(garch11, which=3)


# Vol: EGARCH(1,1) - Mean model: Const
spec2 <- ugarchspec(variance.model = list(model="eGARCH", garchOrder=c(1, 1)), 
                    mean.model = list(armaOrder=c(0,0), include.mean=TRUE), 
                    distribution.model = "std")
egarch11 <- ugarchfit(spec=spec2, data=returns)

print(egarch11)
