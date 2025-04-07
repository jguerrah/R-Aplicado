# Universidad Nacional de Ingenieria
# Reforzamiento en Programacion con R Aplicado
# Jose Guerra
# 2025

# rm(list = ls())

# PAQUETES EN R
# Manipulaci?n de datos
# - dplyr, tidyr, data.table, reshape2, readr, stringr, lubridate
# Visualizaci?n de datos
# - ggplot2, ggvis, rgl
# Econometr?a
# Machine Learning
# - mlr, randomForest, caret, e1071
# Otros
# - esquisse, shiny



# Manipulaci?n de datos
install.packages("tidyverse")
#install.packages('dplyr')

library(tidyverse)
#library(dplyr)

data("mtcars")
data('iris')

mydata <- mtcars
head(mydata)
#mynewdata <- tbl_df(mydata) # depreciado
mynewdata <- as_tibble(mydata)
#tibble::as_tibble()
head(mynewdata)
myirisdata <- as_tibble(iris)

mynewdata
myirisdata

filter(mynewdata, cyl > 4 & gear > 4)
mydata[mydata$cyl > 4 & mydata$gear > 4, ]

filter(mynewdata, cyl > 4)
mydata[mydata$cyl > 4, ]


filter(myirisdata, Species %in% c('setosa', 'virginica'))


select(mynewdata, -cyl, -mpg)

select(mynewdata, -cyl)

select(mynewdata, cyl:wt)

mynewdata %>% 
  select(cyl:wt)

# opcion 1
filter(select(mynewdata, cyl, wt, gear), wt > 2)
# opcion 2
temp <- select(mynewdata, cyl, wt, gear)
filter(temp, wt >2)
# opcion 3
mynewdata %>%
  select(cyl, wt, gear) %>%
  filter(wt > 2)

mynewdata%>%
  select(cyl, wt, gear)%>%
  arrange(wt)

mynewdata%>%
  select(cyl, wt, gear)%>%
  arrange(desc(wt))




mynewdata %>%
  select(mpg, cyl)%>%
  mutate(newvariable = mpg*cyl)

newvariable <- mynewdata %>% mutate(newvariable = mpg*cyl)

myirisdata%>%
  group_by(Species)%>%
  summarise(Average = mean(Sepal.Length, na.rm = TRUE))


myirisdata %>%
  group_by(Species) %>%
  summarise(across(Sepal.Length:Sepal.Width, ~ mean(.x, na.rm = TRUE)))


mynewdata %>% rename(miles = mpg)
