# Universidad Nacional de Ingenieria
# Pre-Maestria
# R Aplicado
# Jose Guerra
# Febrero 2026

install.packages('tsibble')
install.packages('tsibbledata')


library('tsibble')
library('tsibbledata')
library('tidyverse')

# Ejemplo 1
tsibble(
  date = as.Date("2017-01-01") + 0:9,
  value = rnorm(10)
)

# Ejemplo 2
tsibble(
  qtr = rep(yearquarter("2010 Q1") + 0:9, 3),
  group = rep(c("x", "y", "z"), each = 10),
  value = rnorm(30),
  key = group
)

# Ejemplo 3
tsibble(
  mth = rep(yearmonth("2010 Jan") + 0:8, each = 3),
  xyz = rep(c("x", "y", "z"), each = 9),
  abc = rep(letters[1:3], times = 9),
  value = rnorm(27),
  key = c(xyz, abc)
)


gafa_stock
class(gafa_stock)

aapl_stock <- gafa_stock %>%
  filter(Symbol == "AAPL") %>%
  tsibble(index = Date, regular = TRUE) # Ensure regularity and declare index
class(aapl_stock)
aapl_stock


library(feasts)

autoplot(aapl_stock, Close) +
  labs(title = "Apple Stock Closing Prices",
       y = "Price (USD)",
       x = "Date") +
  theme_minimal()

