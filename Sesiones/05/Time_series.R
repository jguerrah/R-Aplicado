# Universidad Nacional de Ingenieria
# R Aplicado
# Jose Guerra
# 2025

# https://www.tidymodels.org/
# tidymodels: machine learning

# https://edubruell.github.io/tidyllm/
# tidyllm: LLM APIs

# https://tidyverts.org/
# tidyverts: time series

install.packages("tidyverse")
install.packages("tsibble")
install.packages("tsibbledata")
install.packages("feasts")
install.packages("fable")

library(tidyverse)
library(tsibble)
library(tsibbledata)
library(feasts)
library(fable)

# Economic indicators featured by the World Bank from 1960 to 2017
df <-  global_economy

df %>% 
  sapply(levels)

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

df <- df %>%
  mutate(date = yearmonth(date)) %>%
  as_tsibble(index=date)
head(df)

df %>%
  autoplot()

?classical_decomposition
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

df %>%
  gg_season(adjusted)

df %>%
  gg_tsdisplay(adjusted, plot_type='partial')

# Modelos SARIMAX
# AR
# MA
# ARIMA
# SARIMA
# SARIMAX

# delta(log(y)) ~ AR(1)
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

df %>% 
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,1))) %>%
  gg_tsresiduals()

#ARMA(1,1)+AR(12)
model <- df %>% 
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,1) + PDQ(1,0,0)))

model %>%
  report()

model %>%
  gg_tsresiduals()

augment(model) %>%
  features(.resid, features = list(mean = mean, sd = sd))

augment(model) %>%
  features(.resid, ljung_box)


# Forecast
model %>%
  forecast() %>%
  autoplot(df)

df %>% 
  filter(date < make_yearmonth(2024,1)) %>%
  model(arima = ARIMA(log(adjusted) ~ pdq(1,1,1) + PDQ(1,0,0))) %>%
  forecast(h=15) %>%
  autoplot(df) +
  geom_vline(xintercept = as_date(make_yearmonth(2024,1)), 
             linetype = 'dashed', color='grey') +
  theme_minimal() +
  labs(x='', y='Precios de AAPL')



models <- df %>%
  filter(date < make_yearmonth(2024,1)) %>%
  model(ets = ETS(log(adjusted)), 
        ar = AR(log(adjusted) ~ order(6)),
        arima = ARIMA(log(adjusted) ~ pdq(1,1,1) + PDQ(1,0,0)))

models %>%
  forecast(h=15) %>%
  autoplot(df)

models %>%
  residuals() %>%
  autoplot(.resid)



# Series multivariadas (VAR)
lung_deaths <- cbind(mdeaths, fdeaths) %>%
  as_tsibble(pivot_longer = FALSE)

lung_deaths %>%
  model(var=VAR(vars(mdeaths, fdeaths) ~ AR(3))) %>%
  report()


df <-  global_economy
df %>%
  select(Growth, Imports, Exports) %>%
  filter(Country == "United States") %>%
  model(VAR(vars(Growth, Imports, Exports) ~ AR(5))) %>%
  report()

df %>%
  select(Growth, Imports, Exports) %>%
  filter(Country == "United States") %>%
  model(VAR(vars(Growth, Imports, Exports) ~ AR(5))) %>%
  IRF() %>%
  gg_irf()

