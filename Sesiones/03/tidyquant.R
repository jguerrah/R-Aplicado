
rm(list=ls())

install.packages('tidyquant')
library('tidyquant')
library('tidyverse')

?tq_get
tq_get_options()
tq_get('META')

data <- tq_get('META', from='2024-01-01')
data
tail(data)

data %>%
  summarise(max_adj=max(adjusted),
            max_close=max(close),
            min_adj=min(adjusted),
            min_close=min(close))

data %>%
  tail(90) %>%
  summarise(max_adj=max(adjusted),
            max_close=max(close),
            min_adj=min(adjusted),
            min_close=min(close))

data %>%
  ggplot(aes(x=date, y=adjusted)) +
  geom_line() +
  labs(x="", y='Precio ajustado') +
  theme_tq()

data %>%
  #tail(30) %>%
  ggplot(aes(x=date)) +
  geom_barchart(aes(open=open, high=high, close=close, low=low)) +
  labs(x="", y='Precios') +
  theme_tq()

data %>%
  #tail(30) %>%
  ggplot(aes(x=date)) +
  geom_candlestick(aes(open=open, high=high, close=close, low=low), 
                   colour_up='darkgreen', fill_up='darkgreen') +
  labs(x="", y='Precios') +
  theme_tq() +
  coord_x_date(xlim=c(as.Date("2024-06-01"), as.Date("2024-07-01")), 
               ylim=c(450,525))

tickers <- c('SPY', 'META', 'QQQ', 'IVE')
data <- tq_get(tickers, from='2024-01-01')

data %>%
  ggplot(aes(x=date, y=adjusted, colour=symbol)) +
  geom_line()

data %>%
  ggplot(aes(x=date, y=adjusted)) +
  geom_line() +
  facet_wrap(~symbol, ncol=2, scale='free_y')

data %>%
  ggplot(aes(x=date)) +
  geom_barchart(aes(open=open, high=high, close=close, low=low)) +
  labs(x="", y='Precios') +
  facet_wrap(~symbol, ncol=2, scale='free_y') +
  theme_tq()

data %>%
  ggplot(aes(x=date, y=adjusted, colour=symbol)) +
  geom_line() +
  geom_ma(ma_fun=SMA, n=30) +
  facet_wrap(~symbol, ncol=2, scale='free_y')

data %>%
  ggplot(aes(x=date, y=adjusted)) +
  geom_barchart(aes(open=open, high=high, close=close, low=low)) +
  geom_ma(ma_fun=SMA, n=30) +
  geom_ma(ma_fun=SMA, n=60, color='green') +
  labs(x="", y='Precios') +
  facet_wrap(~symbol, ncol=2, scale='free_y') +
  theme_tq()


?tq_transmute
tq_mutate_fun_options()

returns <- data %>% 
  group_by(symbol) %>%
  tq_transmute(select=adjusted, 
               mutate_fun=periodReturn, 
               period='daily', type='log')

returns %>%
  ggplot(aes(x=date, y=daily.returns, colour=symbol)) +
  geom_line() +
  labs(x="", y='Retorno') +
  facet_wrap(~symbol, scale='free_y') +
  theme_tq()

?tq_performance
tq_performance_fun_options()

Rb <- returns %>% 
  filter(symbol=='SPY')

returns %>%
  left_join(Rb, by=c('date'='date')) 

returns %>%
  left_join(Rb, by=c('date'='date')) %>%
  tq_performance(Ra=daily.returns.x, 
                 Rb=daily.returns.y, 
                 performance_fun = table.Correlation)

returns %>%
  left_join(Rb, by=c('date'='date')) %>%
  tq_performance(Ra=daily.returns.x, 
                 Rb=daily.returns.y, 
                 performance_fun = table.CAPM, Rf=0.01)

returns %>%
  left_join(Rb, by=c('date'='date')) %>%
  tq_performance(Ra=daily.returns.x, 
                 Rb=daily.returns.y, 
                 performance_fun = SharpeRatio)


?tq_portfolio
returns %>% 
  tq_portfolio(assets_col=symbol, 
               returns_col = daily.returns, 
               weights=c(0.1, 0.5, 0.3, 0.1))

returns %>% 
  tq_portfolio(assets_col=symbol, 
               returns_col = daily.returns, 
               weights=c(0.1, 0.5, 0.3, 0.1)) %>%
  ggplot(aes(x=date, y=portfolio.returns)) +
  geom_line()

returns %>% 
  tq_portfolio(assets_col=symbol, 
               returns_col = daily.returns, 
               weights=c(0.1, 0.5, 0.3, 0.1)) %>%
  ggplot(aes(x=date, y=cumsum(portfolio.returns))) +
  geom_line()

library(tseries)
returns %>%
  select(daily.returns) %>%
  ungroup() %>% 
  pivot_wider(names_from=symbol, 
              values_from=daily.returns)

returns %>% 
  portfolio.optim()




