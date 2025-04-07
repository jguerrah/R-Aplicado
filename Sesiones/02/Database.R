# Universidad Nacional de Ingenieria
# Reforzamiento en Programacion con R Aplicado
# Jose Guerra
# 2025

# rm(list = ls())

# BASES DE DATOS

database <- longley
database

length(database) # n?mero de variables (columnas)
names(database) # nombres de columnas
str(database) # resumen de clase y valores, por columna
summary(database) # estad?sticos descriptivos, por columna

# Seleccionando filas / columnas
GNP <- database$GNP
GNP <- database[["GNP"]]
class(GNP) # vector

GNP <- database["GNP"]
class(GNP) # data frame

df <- database[, c("GNP", "Population")]
class(df) # data frame

A1960 <- database["1960", ]
class(A1960) # data frame
A1960

# Seleccionando grupos de filas / grupos de columnas
database[c("1955", "1960"), ]
database[c("1955", "1960", "1965"), ]

database[5:10, ]
database[ ,1:3]
database[1:2 ,1:3]

head(database, 3) # 3 primeras filas
tail(database, 2) # 2 ?ltimas filas

# Seleccionando en base a variables logical
index <- database$GNP > 350
index
database[index, ]

index2 <- database$Unemployed > 250
index2
database[index2, c(2,3,5)]
database[index2, c("GNP","Unemployed","Population")]

index3 <- c(TRUE, FALSE, TRUE, FALSE, FALSE, FALSE, TRUE)
database[index2, index3]

subset(database, GNP > 350 & Population > 110)


# MODIFICANDO BASE DE DATOS

# Columnas: comando cbind (column binding)
gnpPop <- round(database[, "GNP"]/database[, "Population"],
                2)
gnpPop
class(gnpPop) # vector

database <- cbind(database, GNP.POP = gnpPop) # nueva columna
database
class(database)
str(database)

c_logic <- database$GNP.POP > 3
c_logic
database2 <- cbind(database, GNP3 = c_logic)
database2

# comando merge
db1 <- database[1:6,
                 c("Year", "Population", "Armed.Forces")]
db1
db2 <- database[1:6,
                c("Year", "GNP", "Unemployed")]
db2

db3 <- merge(db1, db2)
db3

# Filas: comando rbind (row binding)
database
names(database)

new_r <- data.frame(118, 560.99,
                    430.1, 293.3,
                    140.910, 1963,
                    43.123, 560.99/43.123)
names(new_r) <- names(database)

database <- rbind(database, new_r) # nueva fila


# Eliminando filas/columnas no deseadas

vector <- 1:10
vector
vector[1:5]
vector[c(2,5)]
vector[-1]
vector[-2]
vector2 <- vector[-c(1,3,5)]
vector2

# base de datos inicial
database
# base de datos sin columnas 7 y 8
database3 <- database[ ,-c(7,8)]
# base de datos sin filas 16 (y 17)
database3 <- database3[-c(16,17),]
database3

db4 <- database[index2, c("GNP","Unemployed","Population")]
db4

vec.na <- c(1,5,9,NA,33,NA)
vec.na
vec.na[!is.na(vec.na)] # selecciona solo si no es NA

# selecciona solo filas donde GNP no es NA
no.na <- !is.na(database$GNP)
no.na
database[no.na, ]

# Otro comando para analizar NA
# complete.cases

# rm(list = ls())

# EJERCICIO
# Cree una funci?n que filtre valores NA
# Y que el filtro solo en las columnas seleccionadas
db <- data.frame(id = c(1,2,3,4,5),
                 renta = c(0, 10, NA, 15, 5),
                 tipo = c(1,2,1,2,1),
                 ingreso = c(NA, 35, 23, 50,30))
db

complete.cases(db)

nafun <- function(data, cols) {
  # creamos vector tipo logical de las columnas especificadas
  # valor TRUE si no NA en la fila, FALSE si NA
  vecnona <- complete.cases(data[cols])
  # seleccionamos solo aquellas filas donde
  # las columnas especificadas no tienen NA
  return(data[vecnona, ])
}

db[complete.cases(db), ]
nafun(db,c(1,2))
nafun(db,c(2,4))
db[complete.cases(db[c(2,4)]), ]
