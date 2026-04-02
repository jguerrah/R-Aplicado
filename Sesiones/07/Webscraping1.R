# Universidad Nacional de Ingenieria
# Pre-Maestria
# R Aplicado
# Jose Guerra
# Marzo 2026

rm(list = ls())

# ---------------------------------
# WebScrapping
# ---------------------------------

# https://finance.yahoo.com/quote/FB2A.F/history/

# https://finance.yahoo.com/quote/FB2A.F/history/
# ?
# period1=1712016000
# &
# period2=1775089026

# https://finance.yahoo.com/quote/FB2A.F/history/
# ?
# period1=1680393600
# &
# period2=1767139200

# https://finance.yahoo.com/quote/FB2A.F/history/
# ?period1=1680393600&period2=1767139200
# &frequency=1wk


# rvest
# https://rvest.tidyverse.org/
install.packages("rvest")
library(rvest)
?rvest


# Ejemplo 1
link <- "https://dataquestio.github.io/web-scraping-pages/simple.html"
web <- read_html(link)
web

web %>%
  html_elements("p")

#/html/body/p
web %>%
  html_elements(xpath="/html/body/p")

web %>%
  html_elements("p") %>%
  html_text()

web %>%
  html_elements(xpath="/html/body/p") %>%
  html_text()


# Ejemplo 2
link <- "https://forecast.weather.gov/MapClick.php?lat=37.7771&lon=-122.4196#.YoF7gajMKUl"
web <- read_html(link)
web

web %>%
  html_elements("p.temp")

web %>%
  html_elements("p.temp") %>%
  html_text()

web %>%
  html_elements("p.temp-low") %>%
  html_text()

web %>%
  html_elements("p.period-name") %>%
  html_text()

# readr
# https://readr.tidyverse.org/
library(readr)
?readr

?parse_number
web %>%
  html_elements("p.temp") %>%
  html_text() %>%
  parse_number()



library(tidyverse)

# Ejemplo aplicado
# RPP
link <- "https://rpp.pe/archivo/2026-03-31"
web <- read_html(link)
web

titles <- web %>%
  html_elements("h2.news__title") %>%
  html_text()
titles

titles[2]


# stringr
# https://stringr.tidyverse.org/
library(stringr)
?stringr

?str_trim
titles |>
  str_trim()

?str_squish
titles <- titles |>
  str_squish()

tags <- web %>%
  html_elements("h3.news__tag") %>%
  html_text() |>
  str_squish()

tibble(Tag = tags, Title = titles)



# Ejemplo aplicado
# BCRP

link <- "https://estadisticas.bcrp.gob.pe/estadisticas/series/diarias/resultados/PD04709XD/html/"
web <- read_html(link)
web

embig <- web %>%
  html_elements(xpath='//*[@id="frmDiarias"]/div[3]/table') %>%
  html_table()
embig <- embig[[1]]
colnames(embig)[2] <- "EMBIG_Peru"
embig

# |>    es con    _
# %>%   es con    .
embig <- web |>
  html_elements(xpath='//*[@id="frmDiarias"]/div[3]/table') |>
  html_table() |>
  _[[1]] |>
  rename_with(.cols=2, ~ "EMBIG_Peru")
embig


web |>
  html_element(xpath='//*[@id="frmDiarias"]/div[3]/table') |>
  html_table() |>
  rename_with(.cols=2, ~ "EMBIG_Peru")
