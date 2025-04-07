# Universidad Nacional de Ingeniería
# Reforzamiento en Programación con R Aplicado
# José Guerra

# rm(list = ls())

data(iris)
head(iris)
tail(iris)

summary(iris)
dim(iris)
names(iris)

hist(iris$Sepal.Length)

hist(iris$Sepal.Length,col='steelblue',main='Histograma',
     xlab='Tama?o',ylab='Frecuencia',freq=FALSE)

# Linea
plot(iris$Sepal.Width,type="l")

# Scatter
plot(iris$Sepal.Width, iris$Sepal.Length)
plot(iris$Sepal.Width, iris$Sepal.Length,col='darkorchid',pch=19)

# Boxplot
boxplot(Sepal.Length~Species,data=iris,
        col=topo.colors(3,alpha=0.7),border='black')
boxplot(iris$Sepal.Length)



plot(iris,col=topo.colors(3,alpha=0.5))