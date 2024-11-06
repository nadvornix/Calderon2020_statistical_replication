library(haven)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggExtra)
library(afex)
library(effectsize)
library(tidyverse)
library(moments)
library(BayesFactor)


data <- read_sav("origdata/Experiment 1.sav")


# Exploratory -------------------------------------------------------------

p1 <- data |> 
  ggplot(aes(x = DV_original)) +
  geom_histogram(binwidth = 1, fill = "blue", color = "black") +
  labs(title = "Histogram of DV_original", x = "DV_original", y = "Count") +
  theme_minimal()
ggsave("figures/exp1histogram_DV_original.png", p1)

# Plotting DV_original for each Likelihood_condition in two separate plots
p2 <- data %>%
  ggplot(aes(x = DV_original, fill = as.factor(Likelihood_condition))) +
  geom_bar(color = "black") +
  labs(title = "Bar Plots of DV_original by Likelihood Condition", 
       x = "DV_original", y = "Count") +
  facet_wrap(~ Likelihood_condition, ncol = 1) +  # Creates one column with two rows
  scale_fill_manual(values = c("5%" = "blue", "95%" = "green"), 
                    name = "Likelihood Condition") +
  theme_minimal()
ggsave("figures/exp1histogram_DV_original_by_condition.png", p2)


# basic statistics of DV_original
data %>%
  group_by(Likelihood_condition) %>%
  summarize(
    mean_DV = mean(DV_original, na.rm = TRUE),
    sd_DV = sd(DV_original, na.rm = TRUE),
    median_DV = median(DV_original, na.rm = TRUE)
  )


p3 <- ggplot(data, aes(x = DV_logtransformed)) +
  geom_bar(fill = "blue", color = "black") +
  facet_wrap(~ Likelihood_condition, ncol=1)
ggsave("figures/exp1histogram_DV_logtransformed_by_condition.png", p3)


# Tests -------------------------------------------------------------------
#TODO: Paper reports 2.49, I am getting 2.46
skewness_value <- skewness(data$DV_original)

n <- sum(!is.na(data$DV_original))
SE_skew <- sqrt(6 / n)

t_test_result <- t.test(DV_logtransformed ~ Likelihood_condition, data = data, var.equal = TRUE)

print(t_test_result)

data$Likelihood_condition_reverse <- factor(data$Likelihood_condition, levels = c(2, 1))
d_result <- cohens_d(DV_logtransformed ~ Likelihood_condition_reverse, data = data, pooled = FALSE)
print(d_result, digits=3)


# Bayes factor ------------------------------------------------------------

bf_result <- ttestBF(
  formula = DV_logtransformed ~ Likelihood_condition,
  data = data,
  nullInterval = c(-Inf, 0), # one sided test
  rscale = 0.707 # Customary cauchy prior
  )

print(1/bf_result)


