# Universidad Nacional de Ingenieria
# Jose Guerra

rm(list=ls())

library(keras)
library(tensorflow)
library(tidyverse)
library(tidymodels) # recipes, yardstick

PFE <- tq_get("PFE", get="stock.prices", from="2010-01-01")

PFE_r <- PFE %>%
  tq_transmute(select=adjusted,
               mutate_fun=periodReturn,
               period="monthly",
               col_rename="monthly_return")

data <- PFE_r |>
  rename(Return = monthly_return) |>
  mutate(Return_lag1 = lag(Return)) |>
  mutate(Return_lag2 = lag(Return_lag1)) |>
  slice(-(1:2))

data

data_split <- initial_split(data, prop = 0.8)
train_data <- training(data_split)
test_data <- testing(data_split)


nn_recipe <- recipe(Return ~ ., data = train_data) %>%
  step_normalize(all_predictors()) %>%
  step_normalize(all_outcomes()) %>%
  prep() # preprocessing

?bake
train_processed <- bake(nn_recipe, new_data = train_data)
test_processed <- bake(nn_recipe, new_data = test_data)

# Matrices para Keras
x_train <- as.matrix(train_processed[, -ncol(train_processed)])
y_train <- as.matrix(train_processed[, ncol(train_processed)])
x_test <- as.matrix(test_processed[, -ncol(test_processed)])
y_test <- as.matrix(test_processed[, ncol(test_processed)])

# Keras
# Sequencial layers
model <- keras_model_sequential() %>%
  layer_dense(units = 32, activation = "relu", input_shape = ncol(x_train)) %>%
  layer_dropout(rate = 0.2) %>%
  layer_dense(units = 16, activation = "relu") %>%
  layer_dense(units = 1) # Output layer for regression

model %>% compile(
  loss = "mse",
  optimizer = optimizer_adam(learning_rate = 0.001),
  metrics = c("mae", "mse")
)

history <- model %>% fit(
  x = x_train,
  y = y_train,
  epochs = 50,
  batch_size = 32,
  validation_split = 0.2 # 20% of training data for validation (during training)
)

plot(history)


predictions_scaled <- model %>% predict(x_test)


metrics <- metrics(
  tibble(
    truth = as.vector(y_test),
    prediction = as.vector(predictions_scaled)
  ),
  truth,
  prediction
)
print(metrics)
