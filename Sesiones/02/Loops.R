# Universidad Nacional de Ingenier?a
# Reforzamiento en Programaci?n con R Aplicado
# José Guerra
# 2025

# rm(list = ls())

# FUNCIONES
f1 <- function(x, y) {
  # Comentarios de la funci?n
  x + y
}

formals(f1)
body(f1)
environment(f1)

x <- 10
y <- 20
f1(x,y)

a <- 5
b <- 8
f1(a,b)
f1(1,2)

# IF / SI
nota <- 29

clasificacion <- if (nota > 90) {
  "A"
} else if (nota > 50) {
  "B"
} else {
  "c"
}

#clasificacion <- if (nota > 90) {
#  "A"
#} else {
#  "B"
#}

clasificacion

evaluacion <- function(x) {
  if (x > 90) {
    "A"
  } else if (x > 50) {
    "B"
  } else if (x > 30) {
    "c"
  } else {
    "D"
  }
}

cat <- evaluacion(nota)
cat


df <- data.frame(Alumno = c("Maria","Juan"),
                 Nota = c(08,12))
df
result <- rep("", times=length(df$Nota))
for (i in 1:length(df$Nota)) {
  if (df$Nota[i] < 10) {
    next
  } else {
    result[i] <- "Ingres?"
  }
}
df <- cbind(df,Resultado=result)
df


a <- if (TRUE) 1 else 2
a
b <- if (1>2) 1 else 2
b

saludo <- function(nombre, birthday = FALSE) {
  paste0(
    "Hola ", nombre, 
    if (birthday) " y feliz cumplea?os!"
  )
}

saludo("Julio")
saludo("Julio", TRUE)
saludo("Julio", birthday = FALSE)

if ("FALSE") 2 else 1 # tipo character se convierten logical
if (TRUE) 2
# se sugiere usar as.logical( )

if (logical()) 1 # error
if (NA) 1 # error

z <- c(TRUE, FALSE)
z
if (z) "Verdadero" else "Falso" # warning

# If vectorial
x <- 1:10
?ifelse
ifelse(x %% 5 == 0, "Verdadero", as.character(x))
# %% es el operador modulo
# El modulo es el residuo de la divisi?n


# rm(list = ls())

# SWITCH / CASOS

opciones <- function(x) {
  if (x == "a") {
    "Opci?n 1"
  } else if (x == "b") {
    "Opci?n 2"
  } else {
    stop("Valor 'x' invalido")
  }
}
opciones("a")
opciones(5) # error

# SWITCH / similar a CASE

opciones <- function(x) {
  switch(x,
         a = "Opci?n 1",
         b = "Opci?n 2",
         stop("Valor 'x' invalido")
  )
}
opciones("a") # revisar si hay bug

piernas <- function(x) {
  switch(x,
         vaca = 4,
         caballo = 4,
         humano = 2,
         planta = 0,
         stop("Input desconocido")
  )
}
piernas("vaca")
piernas("humano")
piernas("planta")

# rm(list = ls())

# FOR / PARA
for (k in 1:3) {
  #Comando a repetir
  print("Buenos d?as")
}

for (k in 11:13) {
  #Comando a repetir
  print("Buenos d?as")
}

for (i in c(1,3,5)) {
  print(paste("Repetici?n n?mero ", i))
}

for (j in 2:3) {
  print(j)
}

i <- 50
for (i in 1:10) {
  if ( i < 3 )
    next
  print(i)
  if (i >= 5)
    break
}

# OTROS
# WHILE & REPEAT
k <- 0
while (k < 5) {
  #print("Primer comando")
  #print(c(1,9,18))
  k <- k + 1
  print(k)
}

# while (TRUE) {
# Primera orden
# Segunda orden
# Orden para cambiar la condici?n de TRUE a FALSO
#}

x <- 60
while (x > 10) {
  print(paste("x es igual a ", x))
  x <- x - 15
}
x

m <- 0
repeat {
  print(m)
  m <- m+2
  if (m>100000) {
    break
  }
}

# Loop infinito?
# Tecla "Esc" o bot?n "Stop" en Console