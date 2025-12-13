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
#library(ggplot2)

data("mtcars")
data('iris')

mydata <- mtcars
head(mydata)
class(mydata)

mynewdata <- as_tibble(mydata)
class(mynewdata)
#tibble::as_tibble()
head(mynewdata)

myirisdata <- as_tibble(iris)

mynewdata
myirisdata


## DPLYR
filter(mynewdata, cyl > 4 & gear > 4)

mydata[mydata$cyl > 4 & mydata$gear > 4, ]
#mydata[1:5, ]


filter(mynewdata, cyl > 4)
mydata[mydata$cyl > 4, ]


filter(myirisdata, Species == 'setosa')

filter(myirisdata, Species %in% c('setosa', 'virginica'))


select(myirisdata, starts_with('Petal'))

select(myirisdata, ends_with('Length'))

select(myirisdata, contains('.'))

select(mynewdata, -cyl, -mpg)

select(mynewdata, -cyl)

select(mynewdata, cyl:wt)

mynewdata %>% select(cyl:wt)
mynewdata |> select(cyl:wt)


# opcion 1
filter(select(mynewdata, cyl, wt, gear), wt > 4)
# opcion 2
temp <- select(mynewdata, cyl, wt, gear)
filter(temp, wt >4)
# opcion 3
mynewdata %>%
  select(cyl, wt, gear) %>%
  filter(wt > 4)


# arrange
mynewdata%>%
  select(cyl, wt, gear)%>%
  arrange(wt)

mynewdata%>%
  select(cyl, wt, gear)%>%
  arrange(desc(wt))

# mutate
mynewdata %>%
  select(mpg, cyl) %>%
  mutate(newvariable = mpg*cyl)

newvariable <- mynewdata %>% 
  mutate(newvariable = mpg*cyl)

# summarise
myirisdata %>%
  group_by(Species)%>%
  summarise(Average = mean(Sepal.Length, na.rm = TRUE))

myirisdata %>%
  summarise(Average = mean(Sepal.Width), n = n(), .by=Species)


myirisdata %>%
  group_by(Species) %>%
  summarise(across(Sepal.Length:Sepal.Width, ~ mean(.x, na.rm = TRUE)))

myirisdata |> 
  filter(Sepal.Length > 4.5) |>
  select(Petal.Length:Species) |>
  group_by(Species) |>
  summarise(avg.pl = mean(Petal.Length), avg.pw = mean(Petal.Width), n=n())

# rename
mynewdata %>% rename(miles = mpg)


## TIDYR

ejemplo <- myirisdata |>
  mutate(id=1:n()) |>
  pivot_longer(cols=starts_with('Sepal'), names_to = 'Type', values_to = 'Size')

myirisdata |> 
  pivot_longer(!Species, names_to = 'Type', values_to = 'Size')

ejemplo
ejemplo |> 
  pivot_wider(names_from=Type, values_from=Size)

mynewdata |> 
  unite('gear_carb', gear:carb, sep='.', remove=FALSE)

mynewdata |> 
  unite('gear_carb', gear:carb, sep='.') |>
  separate(gear_carb, c('gear2', 'carb2'), convert=TRUE)