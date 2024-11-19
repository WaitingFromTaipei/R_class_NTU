library(gvlma)
library(Hmisc)
library(corrplot)
library(mvabund)
library(ggplot2)

# Linear regression
# Model 1 regression: 
# predict a quantitative outcome of a dependent variable y on the basis of one single independent predictor variable x

# y = β_0 + β_1*x + ε

Plant_height <- read.csv(file = "Data/Plant_height.csv", header = TRUE)
mod1_plant<- lm(loght ~ temp, data = Plant_height) # lm(y~x, data)
mod1_plant$coefficients 
# log(plant_height) = (intercept = −0.22566) + (slope = 0.04241)∗temp + ϵ

summary(mod1_plant)
# Call: the function call used to compute the regression model
# Residuals: distribution of the residuals (definition have a mean = 0)
# Coefficient: beta coefficients and their statistical significance
# Residual standard error (RSE), R-squared (R2) and the F-statistic: check how well the model fits to our data



# Coefficients significance

# 1. t-statistic and p-values
# The higher the t-statistic (and the lower the p-value), the more significant the predictor
# High t-statistics (w/ low p-values near 0) -> predictor should be retained in a model
# Very low t-statistics -> predictor could be dropped

# 2. Standard errors and confidence intervals
confint(mod1_plant)



# Model accuracy

# 1. The Residual Standard Error (RSE)
# When comparing two models, one w/ the small RSE -> model fits the best the data
sigma(mod1_plant)*100/mean(Plant_height$loght) # 149.4371, indeed a high variation

# 2. The R-squared (R^2)
# A high value of R2 is a good indication
# For a simple linear regression, R^2 is the square of the Pearson correlation coefficient
# As R^2 tends to increase when more predictors are added (e.g. multiple linear regression model) -> should consider the adjusted R^2 (adjust by df)

# 3. F-statistic:  overall significance
# becomes more important once we start using multiple predictors



# Other useful functions
fitted(mod1_plant) # predicted values
residuals(mod1_plant) # residuals
anova(mod1_plant) # anova table
vcov(mod1_plant) # covariance matrix for model parameters
influence(mod1_plant) # regression diagnostics



plot(mod1_plant) # 會有4張圖

plot(mod1_plant, which = 1)
# Constant variance
# If the plot of residuals versus fitted values is fan-shaped
# the assumption of constant variance (aka homogeneity of variance) is violated
# A log-transformation of the response variable may fix this problem
# Use a different error distribution in a generalised linear model framework (GLM)

dev.off()
# Normality
# by plotting a histogram of the residuals 
# or via a quantile plot where the residuals are plotted against the values expected from a normal distribution
par(mfrow = c(1, 2)) # This code put two plots in the same window
hist(mod1_plant$residuals) # Histogram of residuals
plot(mod1_plant, which = 2) # Quantile plot

# Independence
# `gvlma( )` function in the `gvlma` package
gvmodel <- gvlma(mod1_plant)
summary(gvmodel)



# Two (or more) predictors: Multiple linear regression
# y = β_0 + β_1∗x_1 + β_2∗x_2 + β_3*x_3
mod2_plant<- lm(loght ~ temp + alt + rain, data = Plant_height)

# Evaluate Collinearity
# Variance Inflation Factor (VIF) of each coefficient β_j
# VIF close to 1: absence of multicollinearity.
# VIF larger than 5 or 10: multicolinearity problematic.
# Others considered sqrt(VIF) > 2 as critical limit to consider multicollinearity

car::vif(mod2_plant) # variance inflation factors
sqrt(car::vif(mod2_plant)) > 2 # problem?
summary(mod2_plant)

dev.off()
par(mfrow = c(2, 2))
plot(mod2_plant)



# Model selection
# Bayesian Information Criterion (BIC): BIC(model)= −2∗logLik(model)+npar(model)∗log(n)
# Akaike Information Criterion (AIC): AIC(model)= −2∗logLik(model)+npar(model)∗2

mod3_plant<-lm(formula = loght ~ temp + rain, data = Plant_height)
BIC(mod1_plant); BIC(mod2_plant); BIC(mod3_plant)
AIC(mod1_plant); AIC(mod2_plant); AIC(mod3_plant)



# ANOVA: compares variation between groups to variation within groups
# One-way ANOVA (single factor ANOVA)
# ANOVA is a linear model, just like linear regression except that the predictor variables are categorical rather than continuous

turtles <- read.csv(file = "data/turtles.csv", header = TRUE)
str(turtles) # $Temperature為integer，在此應轉為factor
turtles$Temperature <- factor(turtles$Temperature)

dev.off()
boxplot(Days ~ Temperature, data = turtles, ylab = "Hatching time (days)", xlab = "Temperature (C)")

turtles.aov <- aov(Days ~ Temperature, data = turtles)
summary(turtles.aov)

turtles.lm <- lm(Days ~ Temperature, data = turtles)
anova(turtles.lm) 

summary(turtles.lm)
# (Intercept):58.400 -> mean value of Temperature15
# Temperature20:-13.800 -> mean value of Temperature20 - mean value of Temperature15

# Tukey’s post-hoc test (if rejecting the null hypothesis)
TukeyHSD(turtles.aov)

# Assumptions
par(mfrow = c(1, 3)) # This code put two plots in the same window
hist(turtles.aov$residuals)
plot(turtles.aov, which = 2)
plot(turtles.aov, which = 1)
