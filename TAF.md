# Trabajo Aplicado Final

## Estructura del trabajo

### Parte I

- Descargue de manera automatica información diaria (mínimo 3 años) de al menos 3 acciones de diferentes sectores, y un índice de referencia. 
- Presente la base de datos obtenida.
- Presente estadisticos descriptivos.
- Analice la correlación, y realice al menos 3 gráficos.


### Parte II

- Estudie lor retornos (logaritmicos) diarios de los datos obtenidos en la parte I, incluyendo media, desviación, curtosis, y asimetria.
- Grafique y compare los histogramas de los retornos.
- Asuma que los datos siguen distribución normal, grafique y compare las distribuciones de los retornos.
- El Kolmogorov-Smirnov Goodness-of-Fit Test permite evaluar si una serie sigue una distribución. Utilice el test (función *ks.test* {stats}) para evaluar si los retornos siguen distribución normal.
- Calcule el Value at Risk (VaR) de uno de los activos, tanto el histórico como el parametrico. ¿Por qué difieren?

### Parte III

- Obtenga datos económicos o financieros actuales, presente los datos (distintos a precios de acciones), y grafique.
- Plantee un modelo econometrico (lineal, no lineal, o de series de tiempo).
- Analice los errores del modelo, y grafique (incluyendo un histograma).

## Criterios de evaluación

- **Ejecución**: El código corre sin errores, de inicio a fin
- **Documentación**: Se incluyen comentarios relevantes y breves por bloques de código, explicando la razonabilidad y/o supuestos realizados
- **Razonabilidad**: El código sigue un hilo lógico y coherente, y no redundante
- **Visualización**: Los gráficos son útiles, con títulos, etiquetas de ejes y leyendas

## Entrega

- **Entregable**: Script de R (\*.R) o RMarkdown (\*.Rmd), más dataset utilizado (en caso este no haya sido obtenido automaticamente en el script) 
- **Fecha de entrega**: Hasta el domingo 12/04/2026 a las 23h59
- **Forma de entrega**: Enviar por correo a <jguerrah@uni.pe>, con el asunto "TAF R - *Apellidos, Nombres*" (reemplazar *Apellidos* y *Nombres*)