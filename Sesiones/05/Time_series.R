# Universidad Nacional de Ingenieria
# Pre-Maestria
# R Aplicado
# Jose Guerra
# Marzo 2026

# https://www.tidymodels.org/
# tidymodels: machine learning

# https://edubruell.github.io/tidyllm/
# tidyllm: LLM APIs

# https://tidyverts.org/
# tidyverts: time series


# Introducción: paquete stats (sin instalación)

?ts
valores <- c(10, 12, 15, 14, 18, 22, 25, 20, 24, 28, 32, 30,
             15, 17, 20, 19, 23, 27, 30, 25, 29, 33, 37, 35,
             20, 22, 25, 24, 28, 32, 35, 30, 34, 38, 42, 40)
serie_base <- ts(valores, start = c(2020, 1), frequency = 12)

class(serie_base)

plot(serie_base, main = "Serie Temporal (Base R)")

monthplot(serie_base)

decompose(serie_base)

plot(decompose(serie_base))

?arima


# Paquete zoo & xts
# zoo: Z's Ordered Observations
# xts: eXtensible Time Series (extensión de zoo)

install.packages("xts")
library(xts)

dates <- seq(as.Date("2020-01-01"), by = "month", length.out = 36)
serie_xts <- xts(valores, order.by = dates)

class(serie_xts)

serie_xts["2021"]
serie_xts["2020-06/2021"]

?arima


# Paquete forecast

install.packages("forecast")
library(forecast)

?auto.arima

modelo_arima <- auto.arima(serie_base)
modelo_arima

serie_forecast <- forecast(modelo_arima, h = 12, level = c(90, 95))

plot(serie_forecast)



# fable / tsibble
# alineado con el tidyverse

# tidyverse
install.packages("tidyverse")
# tidyverts
install.packages("tsibble")
install.packages("tsibbledata")
install.packages("feasts")
install.packages("fable")

# tidyverse
library(tidyverse)
# tidyverts
library(tsibble)
library(tsibbledata)
library(feasts)
library(fable)

# Economic indicators featured by the World Bank from 1960 to 2017
df <-  global_economy

class(df)
summarise(df)

levels(df)
?levels
levels(df$Country)


?sapply
df %>%
  sapply(levels)
df |>
  sapply(levels)


df

df <- df %>% 
  mutate(GDPpc = GDP / Population)

df %>%
  autoplot(GDPpc, show.legend =  FALSE)


df %>%
  ggplot(aes(x = Year, y = GDPpc, color = Country)) +
  geom_line() +
  labs(x='', y='PBI per capita') +
  theme_minimal() +
  theme(legend.position = "none")

?slice_max
df %>%
  slice_max(by=Year, order_by = GDPpc, n = 1) %>%
  ggplot(aes(x = Year, y = GDPpc, label = Country)) +
  geom_line() +
  geom_text(nudge_y = 5000, check_overlap = TRUE) +
  labs(x='', y='PBI per capita') +
  theme_minimal() +
  theme(legend.position = "none")

df %>%
  filter(Country %in% c('Monaco','Peru','United States')) %>%
  autoplot(GDPpc)

df %>%
  filter(Country %in% c('Monaco','Peru','United States')) %>%
  ggplot(aes(x = Year, y = log(GDPpc), color = Country)) +
  geom_line() +
  labs(x='', y='PBI per capita (log)') +
  theme_minimal()


?model
# https://cran.r-project.org/web/packages/feasts/feasts.pdf
# https://cloud.r-project.org/web/packages/fable/fable.pdf


library(tidyquant)
df <- tq_get('AAPL', from='2010-01-01')
head(df)

df_r <- df %>%
  tq_transmute(select=adjusted, 
               mutate_fun=periodReturn, 
               period='monthly', type='log')
head(df_r)

df_r %>% 
  ggplot(aes(x=date, y=monthly.returns)) +
  geom_line()

df <- df %>%
  tq_transmute(select=adjusted, 
               mutate_fun=to.monthly)
head(df)

?as_tsibble

# No hay soporte para "yearmon"
df |>
  as_tsibble(index=date)

# Sí hay soporte en esta versión
df |>
  mutate(date = yearmonth(date)) |>
  as_tsibble(index=date)


df <- df %>%
  mutate(date = yearmonth(date)) %>%
  as_tsibble(index=date)
head(df)

df %>%
  autoplot()

?classical_decomposition
?model

df |>
  model(classical_decomposition(adjusted, type="multiplicative"))


df %>%
  model(classical_decomposition(adjusted, type="multiplicative")) %>% 
  components()

df %>%
  model(classical_decomposition(adjusted, type="multiplicative")) %>% 
  components() %>%
  autoplot()

df %>%
  model(classical_decomposition(adjusted, type="additive")) %>% 
  components() %>%
  autoplot()

df %>%
  model(classical_decomposition(adjusted, type="additive")) %>% 
  components() %>%
  ggplot(aes(x = date)) +
  geom_line(aes(y = adjusted, colour = "Precio")) +
  geom_line(aes(y = trend, colour = "Tendencia"))

?gg_season
df %>%
  gg_season(adjusted)

?gg_tsdisplay
df %>%
  gg_tsdisplay(adjusted, plot_type='partial')
df %>%
  gg_tsdisplay(adjusted, plot_type='histogram')
df %>%
  gg_tsdisplay(adjusted, plot_type='scatter')


?gg_lag
df %>%
  gg_lag(adjusted, lags=1:12)

?arima # SARIMAX

# Modelos SARIMAX
# AR
# MA
# ARIMA
# SARIMA
# SARIMAX

# delta(log(y)) ~ AR(1)
?ARIMA
df %>% 
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,0)))

df %>% 
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,0))) %>%
  report()

df_r <- df_r %>%
  mutate(date = yearmonth(date)) %>%
  rename(returns = monthly.returns) %>%
  as_tsibble(index=date)

df_r %>%
  model(arima = ARIMA(returns ~ pdq(1,0,0))) %>%
  report()

# delta(log(y)) ~ ARMA(1,1)
df %>% 
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,1))) %>%
  report()

?gg_tsresiduals
df %>% 
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,1))) %>%
  gg_tsresiduals(type="innovation")

# ARMA(1,1)+AR(12) = SARIMA (1,0,1) (12,0,0)s
model <- df %>% 
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,1) + PDQ(1,0,0)))

model %>%
  report()

model %>%
  gg_tsresiduals()

?augment
augment(model)

?features
augment(model) %>%
  features(.resid, features = list(mean = mean, sd = sd))

augment(model) %>%
  features(.resid, ljung_box)


# Forecast
model %>%
  forecast(h='12 months') %>%
  autoplot(tail(df,36))

df %>% 
  filter(date < make_yearmonth(2025,1)) %>%
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,1) + PDQ(1,0,0))) %>%
  forecast(h=15) %>%
  autoplot(df) +
  geom_vline(xintercept = as_date(make_yearmonth(2025,1)), 
             linetype = 'dashed', color='grey') +
  theme_minimal() +
  labs(x='', y='Precios de AAPL')


?ETS
models <- df %>%
  filter(date < make_yearmonth(2025,1)) %>%
  model(ets = ETS(adjusted), 
        ar = AR(adjusted ~ order(6)),
        arima = ARIMA(log(adjusted) ~ pdq(1,1,1) + PDQ(1,0,0)))
#  model(ets = ETS(log(adjusted)), 
#        ar = AR(log(adjusted) ~ order(6)),
#        arima = ARIMA(log(adjusted) ~ pdq(1,1,1) + PDQ(1,0,0)))

models %>%
  forecast(h=15) %>%
  autoplot(tail(df, 36), level=NULL) +
  geom_vline(xintercept = as_date(make_yearmonth(2025,1)), 
             linetype = 'dashed', color='grey') +
  theme_minimal() +
  labs(x='', y='Precios de AAPL')


# resid vs innov
augment(models)
augment(models) |>
  autoplot(.innov) # .resid

models %>%
  residuals()
models %>%
  residuals() %>%
  autoplot(.resid)


# Series multivariadas (VAR)
lung_deaths <- cbind(mdeaths, fdeaths) %>%
  as_tsibble(pivot_longer = FALSE)

lung_deaths %>%
  model(var=fable::VAR(vars(mdeaths, fdeaths) ~ AR(3))) %>%
  report()

# mdeaths ~ mdeaths(-1) + mdeaths(-2) + mdeaths(-3) + fdeaths(-1) + fdeaths(-2) + fdeaths(-3)
# fdeaths ~ mdeaths(-1) + mdeaths(-2) + mdeaths(-3) + fdeaths(-1) + fdeaths(-2) + fdeaths(-3)

df <-  global_economy
df %>%
  select(Growth, Imports, Exports) %>%
  filter(Country == "United States") %>%
  model(fable::VAR(vars(Growth, Imports, Exports) ~ AR(5))) %>%
  report()

df %>%
  select(Growth, Imports, Exports) %>%
  filter(Country == "United States") %>%
  model(fable::VAR(vars(Growth, Imports, Exports) ~ AR(5))) %>%
  IRF() %>%
  gg_irf()
