# Universidad Nacional de Ingenieria
# Pre-Maestria
# R Aplicado
# Jose Guerra
# Marzo 2026

rm(list = ls())

# ---------------------------------
# WebScrapping
# ---------------------------------

# https://finance.yahoo.com/quote/FB2A.BE/history?p=FB2A.BE
# https://finance.yahoo.com/quote/FB2A.F/history?p=FB2A.F

# Ejemplo de META
# https://query1.finance.yahoo.com/v7/finance/download/
# META?
# period1=1678652769&period2=1710275169
# &interval=1d
# &events=history
# &includeAdjustedClose=true


# https://query1.finance.yahoo.com/v7/finance/download/
# NVDA?
# period1=1678671007&period2=1710293407
# &interval=1d
# &events=history
# &includeAdjustedClose=true


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
titles |>
  str_squish()


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

embig <- web |>
  html_elements(xpath='//*[@id="frmDiarias"]/div[3]/table') |>
  html_table() |>
  _[[1]] |>
  rename_with(.cols=2, ~ "EMBIG_Peru")
embig
