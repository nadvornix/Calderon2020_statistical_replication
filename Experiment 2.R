library(haven)
library(ggplot2)
library(dplyr)
library(tidyr)
library(ggExtra)
library(afex)
library(effectsize)

data <- read_sav("origdata/Experiment 2.sav")

# Exploratory: -------------------------------------------------------------


# It seems that ZGCT has bimodal distribution:
p1 <- data %>%
  select(ZGCT, ZSPT) %>%
  pivot_longer(cols = everything(), names_to = "Variable", values_to = "Z_Score") %>%
  ggplot(aes(x = Z_Score, fill = Variable)) +
  geom_density(alpha = 0.5) +
  labs(
    title = "Faceted Density Plot of Z-Scores",
    x = "Z-Score",
    y = "Density"
  ) +
  facet_wrap(~ Variable, scales = "free") +
  theme_minimal()
ggsave("figures/exp2_densities_of_zgct_and_zspt.png", p1)



# Scatter plot of ZSPT/ZGCT with marginals:
scatter_plot <- ggplot(data, aes(x = ZGCT, y = ZSPT)) +
  geom_count(alpha = 0.6) +
  labs(
    title = "Scatter Plot of Z-Scores with Marginal Densities",
    x = "ZGCT (Z-Score)",
    y = "ZSPT (Z-Score)"
  ) +
  theme_minimal()

# Add marginal density plots
scatter_with_marginals <- ggMarginal(scatter_plot, type = "histogram", margins = "both", size = 5)
ggsave("figures/exp2_scatter_of_z-scores_with_marginals.png", scatter_with_marginals)


# bar plot of age:
barplot_age <- ggplot(data, aes(x = Age)) +
  geom_bar(fill = "skyblue", color = "black") +
  labs(
    title = "Bar Plot of Age",
    x = "Age",
    y = "Frequency"
  )
ggsave("figures/exp2barplot_age.png", barplot_age)


# ANOVA test --------------------------------------------------------------

# Ensure 'Condition' is a factor
data$Condition <- as.factor(data$Condition)

# Ensure 'Condition' is a factor and add descriptive labels
data <- data %>%
  mutate(Condition = factor(Condition, 
                            levels = c(1, 2), 
                            labels = c("SPT likely / GCT unlikely", "GCT likely / SPT unlikely")))

data_long <- data %>%
  pivot_longer(cols = c(ZGCT, ZSPT),
               names_to = "Test",
               values_to = "Score")

# Run the mixed ANOVA
anova_result <- aov_ez(id = "ID",
                       dv = "Score",
                       data = data_long,
                       within = "Test",
                       between = "Condition")
print(anova_result)
# Extract effect size with two-sided 90% CI for partial eta-squared
eta_squared_result <- eta_squared(anova_result, ci =0.90, alternative = "two.sided")
print(eta_squared_result, digits=3)
#TODO: original paper is reporting 90% CI as [.001, .015] and I am getting [0.000, 0.020]


# visualisation from paper -----------------------------------------------------------

# Compute mean and standard error for each combination of Condition and Test
summary_data <- data_long %>%
  group_by(Condition, Test) %>%
  summarise(
    Mean_Score = mean(Score, na.rm = TRUE),
    CI_lower = Mean_Score - qt(0.975, df = n() - 1) * sd(Score, na.rm = TRUE) / sqrt(n()),
    CI_upper = Mean_Score + qt(0.975, df = n() - 1) * sd(Score, na.rm = TRUE) / sqrt(n()),
    .groups = 'drop'
  )

# Plot the results with 95% CI
crossing_plot <- ggplot(summary_data, aes(x = Test, y = Mean_Score, group = Condition, color = Condition)) +
  geom_point(size = 3) +
  geom_line() +
  geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 0.1) +
  scale_x_discrete(limits = c("ZSPT", "ZGCT")) +  # Reverse the order on x-axis
  ylim(-1.5, 1.5) +  # Set y-axis limits from -1.5 to 1.5
  labs(x = "Test", y = "Mean Z-Scored Performance", color = "Condition") +
  theme_minimal()

ggsave("figures/exp2_crossing_plot.png", crossing_plot)

