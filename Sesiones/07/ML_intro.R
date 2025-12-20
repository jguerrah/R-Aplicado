# Universidad Nacional de Ingenieria
# Jose Guerra

rm(list=ls())

# Machine Learning packages:
# caret
# mlr3
# randomForest
# xgboost
# e1071
# etc etc

# https://www.tidymodels.org/learn/
# https://parsnip.tidymodels.org/
library(tidymodels)
library(tidyquant)

# Pfizer Inc.
# pfizer Inc. discovers, develops, manufactures, markets, distributes, and sells 
# biopharmaceutical products in the United States and internationally.
PFE <- tq_get("PFE", get="stock.prices", from="2010-01-01")
PFE |>
  ggplot(aes(date, adjusted)) +
  geom_candlestick(aes(open = open, high = high, low = low, close = close)) +
  labs(title = "Candlestick Chart", 
       y = "Closing Price", x = "") +
  theme_tq()

PFE_r <- PFE %>%
  tq_transmute(select=adjusted,
               mutate_fun=periodReturn,
               period="monthly",
               col_rename="monthly_return")
PFE_r %>%
  ggplot(aes(date, monthly_return)) +
  geom_line() +
  labs(title = "Historicals returns", 
       y = "Monthly returns", x = "") +
  theme_tq()

data <- PFE_r |>
  rename(Return = monthly_return) |>
  mutate(Return_lag1 = lag(Return)) |>
  slice(-1)


data_split <- initial_split(data, prop = 0.8)
train <- training(data_split)
test <- testing(data_split)

?recipe
recipe <- recipe(Return ~ Return_lag1, data = train) %>%
  step_normalize(all_numeric_predictors())

# Linear regression
lr_spec <- linear_reg() %>%
  set_engine("lm") %>%
  set_mode("regression")

# Workflow
workflow <- workflow() %>%
  add_recipe(recipe) %>%
  add_model(lr_spec)

# Fit
lr_fit <- workflow %>%
  fit(data = train)

tidy(lr_fit)

final_results <- workflow %>%
  last_fit(split = data_split)

collect_metrics(final_results)

predictions <- collect_predictions(final_results)
predictions

ggplot(predictions, aes(x = Return, y = .pred)) +
  geom_point(alpha = 0.5) +
  geom_abline(lty = 2, color = "red") +
  labs(title = "Actual vs. Predicted Return (tidymodels)",
       x = "Actual",
       y = "Predicted")

#install.packages("ranger")
rf_spec <- rand_forest(mode = "regression", trees = 1000) %>%
  set_engine("ranger")
rf_fit <- rf_spec %>%
  fit(Return ~ Return_lag1, data = train)
print(rf_fit)