# Universidad Nacional de Ingenier?a
# Reforzamiento en Programaci?n con R Aplicado
# José Guerra
# 2025

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
head(mpg)
summary(mpg)

?ggplot
# ggplot construye el objeto inicial / plantilla
ggplot(data = mpg) # no tiene sentido as? solo

# Diagrama de dispersi?n (Scatter)
?geom_point
# objeto inicial (database) + geom_point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

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
ggplot(mpg, mapping = aes(displ, hwy)) + 
  geom_smooth() + 
  geom_point()

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
head(diamonds)
summary(diamonds)

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

?stat_count
# stat = "count", por defecto (ver ayuda)
ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

# Relativa (%)
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop), group = 1)) +
  coord_flip()

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")

ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) + 
  geom_bar(fill = NA, position = "identity")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")


df <- diamonds


ggplot(data = df) + 
  geom_bar(mapping = aes(x = cut))
+
  geom_text(aes(label=c(5000,10000,15000, 20000, 30000)))
# agregar labels en las barras



# Revisar:
# https://stats.idre.ucla.edu/r/codefragments/ggplot2_errorbar
# https://ggplot2.tidyverse.org/
# https://ggplot2-book.org/
# https://r4ds.had.co.nz/data-visualisation.html
# https://exts.ggplot2.tidyverse.org/gallery/