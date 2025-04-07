# Universidad Nacional de Ingenieria
# R Aplicado
# José Guerra

rm(list = ls())

# Fuente: https://github.com/woerman/ResEcon703
# Topics in Advanced Econometrics (ResEcon 703)
# University of Massachusetts Amherst, taught by Matt Woerman

library(tidyverse)
direccion = 'https://raw.githack.com/woerman/ResEcon703/master/slides/week_04/ac_renters.csv'
ac_data <- read_csv(direccion)
ac_data

### Model air conditioning as a binary logit
## Model air conditioning as a function of cost variables
binary_logit <- glm(formula = 
                      air_conditioning ~ cost_system + cost_operating, 
                    family = 'binomial', 
                    data = ac_data)
## Summarize model results
summary(binary_logit)
## Display model coefficients
coef(binary_logit)


### Calculate the fitted values of the model 
## Calculate utility of air conditioning
ac_data <- ac_data %>% 
  mutate(utility_ac_logit = predict(binary_logit))
## Look at utilities and other data
ac_data %>% 
  select(air_conditioning, starts_with('cost'), utility_ac_logit)


### Visualize utility of air conditioning adoption
## Plot density of utilities
ac_data %>% 
  ggplot(aes(x = utility_ac_logit)) +
  geom_density() +
  xlab('Utility of air conditioning') +
  ylab('Kernel Density')

ac_data %>%
  ggplot(aes(x=utility_ac_logit, y=air_conditioning)) +
  geom_point()

## Plot fraction vs. utility of air conditioning using bins
ac_data %>% 
  mutate(bin = cut(utility_ac_logit,
                   breaks = seq(-3, 2, 0.25),
                   labels = 1:20)) %>%
  group_by(bin) %>% 
  summarize(fraction_ac = mean(air_conditioning), .groups = 'drop') %>% 
  mutate(bin = as.numeric(bin),
         bin_mid = 0.25 * (bin - 1) - 2.875) %>% 
  ggplot(aes(x = bin_mid, y = fraction_ac)) +
  geom_point() +
  xlab('Utility of air conditioning') +
  ylab('Fraction with air conditioining')


### Calculate the choice probabilities implied by the model 
## Calculate choice probability of air conditioning
ac_data <- ac_data %>% 
  mutate(probability_ac_logit = 1 / (1 + exp(-utility_ac_logit)))
## Look at utilities and probabilities
ac_data %>% 
  select(air_conditioning, utility_ac_logit, probability_ac_logit)

### Visualize probability of air conditioning adoption
## Plot density of probabilities
ac_data %>% 
  ggplot(aes(x = probability_ac_logit)) +
  geom_density() +
  xlab('Probability of air conditioning') +
  ylab('Kernel Density')

ac_data %>%
  ggplot(aes(x=probability_ac_logit, y=air_conditioning)) +
  geom_point()

## Plot fraction vs. probability of air conditioning using bins
ac_data %>% 
  mutate(bin = cut(probability_ac_logit,
                   breaks = seq(0, 1, 0.05),
                   labels = 1:20)) %>%
  group_by(bin) %>% 
  summarize(fraction_ac = mean(air_conditioning), .groups = 'drop') %>% 
  mutate(bin = as.numeric(bin),
         bin_mid = 0.05 * (bin - 1) + 0.025) %>% 
  ggplot(aes(x = bin_mid, y = fraction_ac)) +
  geom_point() +
  xlab('Probability of air conditioning') +
  ylab('Fraction with air conditioning')


### Calculate marginal effects and elasticities
## Calculate the marginal effect of each cost variable
ac_data <- ac_data %>% 
  mutate(marg_eff_system = coef(binary_logit)[2] * 
           probability_ac_logit * (1 - probability_ac_logit),
         marg_eff_operating = coef(binary_logit)[3] * 
           probability_ac_logit * (1 - probability_ac_logit))
## Calculate the elasticity of each cost variable
ac_data <- ac_data %>% 
  mutate(elasticity_system = coef(binary_logit)[2] * 
           cost_system * (1 - probability_ac_logit),
         elasticity_operating = coef(binary_logit)[3] * 
           cost_operating * (1 - probability_ac_logit))
## Look at marginal effects and elasticities
ac_data %>% 
  select(starts_with('marg_eff'), starts_with('elasticity'))
## Summarize marginal effects and elasticities
ac_data %>% 
  select(starts_with('marg_eff'), starts_with('elasticity')) %>% 
  summary()


### Model air conditioning with heterogeneous cost coefficients
## Model air conditioning as a function of costs divided by income
binary_logit_inc <- glm(formula = air_conditioning ~ I(cost_system / income) + 
                          I(cost_operating / income), 
                        family = 'binomial', 
                        data = ac_data)
## Summarize model results
summary(binary_logit_inc)
## Display model coefficients
coef(binary_logit_inc)

### Visualize income variable
## Plot kernel density of income
ac_data %>% 
  ggplot(aes(x = income)) +
  geom_density() +
  xlab('Income') +
  ylab('Kernel density')


### Calculate marginal utility of cost variables
## Calculate marginal utility of costs when income == 30
coef(binary_logit_inc)[2:3] / 30
## Calculate marginal utility of costs when income == 60
coef(binary_logit_inc)[2:3] / 60
## Calculate marginal utility of costs when income == 90
coef(binary_logit_inc)[2:3] / 90


### Calculate the trade-off between system cost and operating cost
## Calculate system cost equivalence of an increase in operating cost
-coef(binary_logit)[3] / coef(binary_logit)[2]

### Calculate the implied discount factor of consumers
## Calculate the implied discount rate
coef(binary_logit)[2] / coef(binary_logit)[3]


# Logit Multinomial
install.packages('mlogit')
library(mlogit)

?dfidx
?mlogit

