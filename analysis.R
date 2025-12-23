# bank marketing regression analysis
# dataset from UC Irvine ML Repository

# load the data
data <- read.csv("data/bank-full.csv", sep=";", header=TRUE)

# quick look at what we got
str(data)
summary(data)

# check for missing values
colSums(is.na(data))

# convert subscription variable to numeric (yes=1, no=0)
data$y_numeric <- ifelse(data$y == "yes", 1, 0)

# pick the variables we want for regression
regression_data <- data.frame(
  subscription = data$y_numeric,
  age = data$age,
  balance = data$balance,
  duration = data$duration,
  campaign = data$campaign,
  previous = data$previous
)

# clean up any missing data (probably none but just in case)
regression_data <- na.omit(regression_data)

# summary statistics
summary(regression_data)
sapply(regression_data, sd)

# save summary stats to file
sink("output/summary_statistics.txt")
cat("Summary Statistics\n\n")
print(summary(regression_data))
cat("\nStandard Deviations:\n")
print(sapply(regression_data, sd))
sink()

# run the regression
# model: Subscription = β0 + β1(Age) + β2(Balance) + β3(Duration) + β4(Campaign) + β5(Previous) + ε
model <- lm(subscription ~ age + balance + duration + campaign + previous,
            data = regression_data)

# check results
summary(model)

# save results to file
sink("output/regression_results.txt")
cat("Regression Results\n\n")
print(summary(model))
sink()

# get confidence intervals for coefficients
confint(model)

sink("output/confidence_intervals.txt")
cat("95% Confidence Intervals\n\n")
print(confint(model))
sink()

# r-squared - tells us how much variation in Y is explained by our model
# adjusted r-squared - same but penalizes for adding too many variables
summary(model)$r.squared
summary(model)$adj.r.squared

# diagnostic plots - checking if our regression assumptions are met
png("output/residual_plots.png", width = 1200, height = 1200, res = 150)
par(mfrow = c(2, 2))  # 2x2 grid of plots
plot(model)
dev.off()

# make some predictions
# prediction 1: average person but longer contact duration
new_client_1 <- data.frame(
  age = mean(regression_data$age),
  balance = mean(regression_data$balance),
  duration = mean(regression_data$duration) * 1.5,  # 50% longer than avg
  campaign = mean(regression_data$campaign),
  previous = mean(regression_data$previous)
)

predict(model, new_client_1, interval = "prediction")

# prediction 2: young person with decent balance
new_client_2 <- data.frame(
  age = 30,
  balance = 5000,
  duration = mean(regression_data$duration),
  campaign = 2,
  previous = 0
)

predict(model, new_client_2, interval = "prediction")

# save predictions to file
sink("output/predictions.txt")
cat("Predictions\n\n")
cat("Scenario 1: Average client with 50% longer contact\n")
print(new_client_1)
cat("\nPrediction:\n")
print(predict(model, new_client_1, interval = "prediction"))

cat("\n\nScenario 2: Young client with 5000 balance\n")
print(new_client_2)
cat("\nPrediction:\n")
print(predict(model, new_client_2, interval = "prediction"))
sink()

cat("\nDone! Check the output folder for results.\n")
