# Universidad Nacional de Ingenieria
# Pre-Maestria
# R Aplicado
# Jose Guerra
# Febrero 2026

# rm(list = ls())


# Intro
# Tidyverse es un conjunto de paquetes dise?ados para data science
# Al cargar tidyverse, se carga su core, que incluye:
# ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats
# tidyverse tambi?n incluye otros paquetes, pero no se cargan por defecto
# ver https://www.tidyverse.org/packages/

# Para usar alguno de los paquetes del tidyverse podemos:
# install.packages("tidyverse")
# o especificar el paquete que queremos
# install.packages("ggplot2")


# Gr?ficos con ggplot2

# al cargar tidyverse, se carga su core (incluido ggplot2)
# revisar lista de paquetes cargados en Packages
library(tidyverse)
# tambi?n podemos cargar direcamente ggplot2
library(ggplot2)

rm(list=ls())

# ggplot2 incluye la base de datos mpg
# https://ggplot2.tidyverse.org/reference/mpg.html
mpg
head(mpg)
summary(mpg)
#####
# manufacturer: manufacturer name
# model: model name
# displ: engine displacement, in litres
# year: year of manufacture
# cyl: number of cylinders
# trans: type of transmission
# drv: the type of drive train, where f = front-wheel drive, r = rear wheel drive, 4 = 4wd
# cty: city miles per gallon
# hwy: highway miles per gallon
# fl: fuel type
# class: "type" of car
#####

?ggplot
# ggplot construye el objeto inicial / plantilla
ggplot()
ggplot(data = mpg) # no tiene sentido as? solo

# Diagrama de dispersi?n (Scatter)
?geom_point
# objeto inicial (database) + geom_point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
# plot general
plot(mpg$displ, mpg$hwy)
plot(mpg$displ, mpg$hwy, type='p', xlab='displ', ylab='hwy')

# por class - color
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# objeto inicial con car?cteristicas
# Notese que a esta versi?n de plantilla solo le falta el gr?fico 
ggplot(mpg, aes(displ, hwy, colour = class)) + 
  geom_point()
# Resultado id?ntico a la anterior al scatter anterior

# por class - tama?o
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = cyl))

# por class - alpha (transparencia)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = cyl))

# por class - shape
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
# por defecto no deja graficar m?s de 6 grupos en scatter

# por class, separados
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# por class, agrupados por valores de cyl
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)

# por class, agrupados por valores de drv y cyl
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv  ~ cyl)


# L?neas
?geom_smooth

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# Recodar que tambi?n podemos definir el objeto inicial
# con las caracteristicas de los gr?ficos a llamar
ggplot(mpg, mapping = aes(displ, hwy))
ggplot(mpg, mapping = aes(displ, hwy)) + 
  geom_smooth() + 
  geom_point()

ggplot()
ggplot() + 
  geom_smooth(data = mpg, mapping = aes(displ, hwy)) + 
  geom_point(data = mpg, mapping = aes(displ, hwy))


# por drv
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))


ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()
# Notar que ya podemos graficar m?s de 6 grupos (gracias a 'mapping')

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)


# Barras
?geom_bar
# Base de datos diamonds (de ggplot2)
# https://ggplot2.tidyverse.org/reference/diamonds.html
head(diamonds)
summary(diamonds)
#####
# price: price in US dollars ($326–$18,823)
# carat: weight of the diamond (0.2–5.01)
# cut: quality of the cut (Fair, Good, Very Good, Premium, Ideal)
# color: diamond colour, from D (best) to J (worst)
# clarity: a measurement of how clear the diamond is (I1 (worst), SI2, SI1, VS2, VS1, VVS2, VVS1, IF (best))
# x: length in mm (0–10.74)
# y: width in mm (0–58.9)
# z: depth in mm (0–31.8)
# depth: total depth percentage = z / mean(x, y) = 2 * z / (x + y) (43–79)
# table: width of top of diamond relative to widest point (43–95)
#####


ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

?stat_count
# stat = "count", por defecto (ver ayuda)
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))


# Relativa (%)
?after_stat
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1))

# horizontal
?coord_flip
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1)) +
  coord_flip()

# color (bordes)
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))

# color (fill)
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

# sub-grupos (columna clarity)
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position="identity")

# alpha (transparencia)
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")

# input 'position'
?geom_bar
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "nudge")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

df <- diamonds


ggplot(data = df) + 
  geom_bar(mapping = aes(x = cut))

ggplot(data = df, mapping = aes(x = cut)) + 
  geom_bar(fill='steelblue') +
  geom_text(aes(label=after_stat(count)), stat='count', vjust = -0.2) +
  labs(title='Grafico de barras', x='Corte', y='Conteo') +
  theme_minimal()
