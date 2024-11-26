library(gvlma)
library(Hmisc)
library(corrplot)
library(mvabund)
library(ggplot2)
library(lme4)

# Factorial ANOVA

# six combinations of copper enrichment (“None”,“Low”,“High”) and orientation (“Vertical”,“Horizontal”)
sessile <- read.csv(file = "data/sessile.csv", header = TRUE)

# check your predictors with `str`
boxplot(Richness ~ Copper * Orientation, data = sessile,
        names = c("High.H", "Low.H", "None.H", "High.V", "Low.V", "None.V"),
        ylab = "Species richness", xlab = "Copper/Orientation", ylim = c(0, 80))

# The factorial ANOVA will test:
# whether there are any differences in richness among the three levels of copper enrichment
# whether there are any differences in richness among the two levels of substrate orientation
# whether there is any interaction between copper and orientation

# You have three null hypotheses:
# there is no difference between the means for each level of copper, Ho: μ_none=μ_low=μ_high
# there is no difference between the means for each level of orientation, Ho: μ_vertical=μ_horizontal
# there is no interaction between the factors

sessile.aov <- aov(Richness ~ Copper * Orientation, data = sessile)
# same as:
sessile.aov <- aov(Richness ~ Copper + Orientation + Copper:Orientation, data = sessile)
summary(sessile.aov)
# same as:
sessile.lm <- lm(Richness ~ Copper * Orientation, data = sessile)
anova(sessile.lm)
# there is strong evidence to reject all three null hypotheses

# the interpretation of the main effects becomes more complex
# it is better to limit your interpretation to the interaction term
interaction.plot(sessile$Copper, sessile$Orientation, sessile$Richness)

# If there is no interaction, you can run a post-hoc test on each of the main effects
# (only needed if there are more than two levels for an effect). 

# If there is an interaction, you will need to consider post-hoc tests 
# that contrast the means from all combinations of both factors.



# Nested ANOVA

# each level of one of the factors is unique to only one level of the other factor
# These designs have different sources of variance to the factorial designs, and do not have an interaction term

# Input data file and check the structure of the data
mink <- read.csv(file = "data/mink.csv", header = TRUE)
# grouped boxplot
ggplot(mink, aes(x=Treatment, y=Voles, fill=Area)) + 
  geom_boxplot()
Mink.nested <- aov(Voles ~ Treatment + Area %in% Treatment, data = mink)
summary(Mink.nested)



# GLMs: when the distribution of data do not conform to the assumptions of linear models
# specifically the assumptions of normally distributed residuals and no relationship between the variance and the mean

# important assumption:
# 1. The observed y are independent, conditional on some predictors x
# 2. The response y come from a known distribution with a known mean-variance relationship
# 3. There is a straight line relationship between a known function g of the mean of y and the predictors x

# g(μy) = α + β1*x1 + β2*x2+ ... -> link functions g() are an important part of fitting GLM’s

# Binomial example
Crab_PA <- read.csv("data/crabs.csv", header = T)
head(Crab_PA)
ft.crab <- glm(CrabPres ~ Time * Dist, family = binomial, data = Crab_PA)

# Before we look at the results of our analysis it’s important to check that our data met the assumptions of the model we used.
# Assumption 1 -> If your experimental design involves any pseudo-replication, this assumption will be violated
# Assumption 2 -> check that the distribution models the mean-variance relationship of our data well
plot(ft.crab, which = 1)

# For a small sample it is often better to use resampling to calculate p-values
# we can instead fit the model using the `manyglm` function in the `mvabund` package
ft.crab.many <- manyglm(CrabPres ~ Time * Dist, family = "binomial", data = Crab_PA)
plot(ft.crab.many)

# Assumption 3 -> check the residual plot above for non-linearity, or a U-shape

# For binomial models in particular the p-values from the `summary` function can be funny
# the use of the `anova` function is often preferred to see if predictors are significant
anova(ft.crab, test = "Chisq")

# For a small sample it is often better to use resampling to calculate p-values.
anova(ft.crab.many)
# Inference was carried out using bootstrap resampling with 1000 resamples (default when using `manyglm`)

summary(ft.crab) # logit(p)=−3.01+0.26∗Time−0.03∗Dist+0.01∗Time∗Dist



# Poisson example
Reveg <- read.csv("data/revegetation.csv", header = T)
head(Reveg)
hist(Reveg$Soleolifera) # The Poisson distribution assumes the variance equals the mean

ft.sol.pois <- manyglm(Soleolifera ~ Treatment, family = "poisson", data = Reveg)
plot(ft.sol.pois) 
# The residuals are more spread out on the right than the left - we call this overdispersion

ft.sol.nb <- manyglm(Soleolifera ~ Treatment, family = "negative binomiale", data = Reveg)
plot(ft.sol.nb)

anova(ft.sol.nb)
summary(ft.sol.nb)
ft.sol.nb$coefficients #log(λ)=−0.92+2.12×Treatment
boxplot(Soleolifera ~ Treatment, ylab = "Count", xlab = "Treatment", data = Reveg)



# Mixed models: with a mixture of fixed and random effects

# A random factor:
# is categorical
# has a large number of levels
# only a random subsample of levels is included in your design
# you want to make inference in general, and not only for the levels you observed

# Assumptions of mixed models
# The observed y are independant, conditional on some predictor x
# The response y are normally distributed, conditional on some predictors x
# The response y has constant variance, conditional on some predictors x
# There is a straight line relationship between y and the predictors x and random effects z
# Random effect z are independant of y
# Random effect z are normally distributed

Estuaries <- read.csv("data/estuaries.csv", header = T)

ft.estu <- lmer(Total ~ Modification + (1 | Estuary), data = Estuaries, REML = T)
# where Total is the dependent variable (left of the ~), Modification is the fixed effect, and Estuary is the random effect.
# Note the syntax for one random effect is (1|Estuary) - this is fitting a different intercept (hence 1) for each Estuary.
# This model can be fit by maximum likelihood (REML=F) or restricted maximum likelihood (REML=T)

# Assumption 2
qqnorm(residuals(ft.estu))
# Assumption 3
scatter.smooth(residuals(ft.estu) ~ fitted(ft.estu))

# The package lme4 won’t give you p-values for fixed effects as part of the output in summary
# This is because the p-values from Wald tests (using `summary`) and likelihood ratio tests (using `anova`) are only approximate in mixed models.

ft.estu <- lmer(Total ~ Modification + (1 | Estuary), data = Estuaries, REML = F)
ft.estu.0 <- lmer(Total ~ (1 | Estuary), data = Estuaries, REML = F)

anova(ft.estu.0, ft.estu)
confint(ft.estu) #confidence intervals

# parametric bootstrap
nBoot <- 1000
lrStat <- rep(NA, nBoot)
ft.null <- lm(Total ~ Modification, data = Estuaries) # null model
ft.alt <- lmer(Total ~ Modification + (1 | Estuary), data = Estuaries, REML = F) # alternate model
lrObs <- 2 * logLik(ft.alt) - 2 * logLik(ft.null) # observed test stat
for (iBoot in 1:nBoot)
{
  Estuaries$TotalSim <- unlist(simulate(ft.null)) # resampled data
  bNull <- lm(TotalSim ~ Modification, data = Estuaries) # null model
  bAlt <- lmer(TotalSim ~ Modification + (1 | Estuary), data = Estuaries, REML = F) # alternate model
  lrStat[iBoot] <- 2 * logLik(bAlt) - 2 * logLik(bNull) # resampled test stat
}
mean(lrStat > lrObs) # P-value for test of Estuary effect

