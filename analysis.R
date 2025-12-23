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
# now using duration as the dependent variable (continuous outcome)
regression_data <- data.frame(
  duration = data$duration,
  age = data$age,
  balance = data$balance,
  campaign = data$campaign,
  previous = data$previous,
  subscription = data$y_numeric
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
# model: Duration = β0 + β1(Age) + β2(Balance) + β3(Campaign) + β4(Previous) + β5(Subscription) + ε
model <- lm(duration ~ age + balance + campaign + previous + subscription,
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
# prediction 1: average client who subscribes
new_client_1 <- data.frame(
  age = mean(regression_data$age),
  balance = mean(regression_data$balance),
  campaign = mean(regression_data$campaign),
  previous = mean(regression_data$previous),
  subscription = 1  # subscribes
)

predict(model, new_client_1, interval = "prediction")

# prediction 2: young client with high balance who doesn't subscribe
new_client_2 <- data.frame(
  age = 30,
  balance = 5000,
  campaign = 2,
  previous = 0,
  subscription = 0  # doesn't subscribe
)

predict(model, new_client_2, interval = "prediction")

# save predictions to file
sink("output/predictions.txt")
cat("Predictions\n\n")
cat("Scenario 1: Average client who subscribes\n")
print(new_client_1)
cat("\nPredicted call duration:\n")
print(predict(model, new_client_1, interval = "prediction"))

cat("\n\nScenario 2: Young client with 5000 balance who doesn't subscribe\n")
print(new_client_2)
cat("\nPredicted call duration:\n")
print(predict(model, new_client_2, interval = "prediction"))
sink()

cat("\nDone! Check the output folder for results.\n")
