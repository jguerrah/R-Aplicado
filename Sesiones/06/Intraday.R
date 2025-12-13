
library(quantmod)

ticker <- "AAPL"
period <- "60min" # 30min, 15min, etc.

data <- getSymbols(ticker, src = "yahoo", 
                   periodicity = period, auto.assign = FALSE)
data

?chartSeries
chartSeries(data, theme = chartTheme("white"), 
            name = "AAPL Intraday (60 min)")

chartSeries(data, subset = "last 5 days",
            theme = chartTheme("white"), name = "AAPL Intraday (60 min)")

library(dplyr)
library(ggplot2)

data <- data.frame(Date = index(data), coredata(data))
ggplot(data, aes(x = Date, y = AAPL.Adjusted)) +
  geom_line() +
  labs(title = "AAPL Adjusted Close (60 min)", x = "Time", y = "Price")
