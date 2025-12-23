# Multiple Regression Analysis of Bank Marketing Data

## 1. Research Question

This study looks at how different customer characteristics affect whether they'll subscribe to a term deposit. Basically we're trying to figure out - what makes someone more likely to say yes when the bank calls them?

The main variables we're looking at are age, account balance, how long the last phone call was, how many times they contacted them during the campaign, and previous contact history.

## 2. Dataset Description

Using the Bank Marketing dataset from UC Irvine Machine Learning Repository. It's from a Portuguese bank's direct marketing campaigns (phone calls) from May 2008 to November 2010.

Dataset info:
- 45,211 client contacts total
- 17 variables (using 6 for this analysis)
- Target: did they subscribe to a term deposit or not

The data has client info, campaign details, and the outcome (yes/no subscription).

## 3. Data Inspection and Cleaning

Loaded the full dataset into R and checked it out using str() and summary().

What we did:
- Loaded bank-full.csv (45,211 rows)
- Checked for missing values - didn't find any in the variables we're using
- Converted the outcome variable from "yes"/"no" to 1/0 so we can run regression
- Pulled out just the numeric variables we need
- No missing data in the final dataset

## 4. Summary Statistics

[TODO: Fill in after running analysis.R]

Basic stats for the variables:

| Variable | Mean | Std Dev | Min | Max |
|----------|------|---------|-----|-----|
| Subscription | [X] | [X] | 0 | 1 |
| Age | [X] | [X] | [X] | [X] |
| Balance | [X] | [X] | [X] | [X] |
| Duration | [X] | [X] | [X] | [X] |
| Campaign | [X] | [X] | [X] | [X] |
| Previous | [X] | [X] | [X] | [X] |

Balance and duration have a lot of variation - some people have negative balances, some super high. Contact duration varies a lot too.

## 5. Model Specification

Running a multiple regression:

**Subscription = β₀ + β₁(Age) + β₂(Balance) + β₃(Duration) + β₄(Campaign) + β₅(Previous) + ε**

Where:
- Y = Subscription (0 or 1)
- X's = Age, Balance, Duration, Campaign, Previous

Using basic OLS regression with lm() in R.

## 6. Regression Results and Coefficient Interpretation

[TODO: Fill in coefficients after running analysis]

| Variable | Coefficient | Std Error | t-value | p-value |
|----------|------------|-----------|---------|---------|
| Intercept | [X] | [X] | [X] | [X] |
| Age | [X] | [X] | [X] | [X] |
| Balance | [X] | [X] | [X] | [X] |
| Duration | [X] | [X] | [X] | [X] |
| Campaign | [X] | [X] | [X] | [X] |
| Previous | [X] | [X] | [X] | [X] |

What this means:
- **Duration** - this is probably going to be the big one. Longer phone calls = more likely to subscribe
- **Balance** - people with more money might be slightly more likely to subscribe
- **Age, Campaign, Previous** - probably not as important

## 7. Statistical Significance

Looking at p-values (α = 0.05):

[TODO: Add after running]

Expected:
- Duration and Balance should be significant (p < 0.05)
- The other variables probably won't be

If p < 0.05, means it's probably a real relationship and not just random chance.

## 8. Confidence Intervals

95% confidence intervals for the coefficients:

[TODO: Fill in from output]

| Variable | Lower CI | Upper CI |
|----------|----------|----------|
| Age | [X] | [X] |
| Balance | [X] | [X] |
| Duration | [X] | [X] |
| Campaign | [X] | [X] |
| Previous | [X] | [X] |

If the interval doesn't include zero, the variable matters. If it does include zero, not significant.

## 9. Coefficient of Determination (R²)

[TODO: Add R² value]

R² = [X]
Adjusted R² = [X]

This means about [X]% of the variation in subscriptions is explained by these variables. The rest is other stuff we're not measuring.

Since we're using regular regression on a binary outcome (0/1), the R² isn't perfect but gives a general idea of fit. Logistic regression would be better here but this works for now.

## 10. Residual Diagnostics

We created 4 diagnostic plots to check if the regression assumptions hold:
1. Residuals vs Fitted - checking for patterns
2. Q-Q Plot - checking if residuals are normal
3. Scale-Location - checking variance
4. Residuals vs Leverage - looking for outliers

[See output/residual_plots.png]

Expected issues:
- Since we're using linear regression on binary data, there'll be some weirdness in the residuals
- Should still be roughly okay though

## 11. Prediction

We made predictions for two scenarios:

**Scenario 1: Average client but longer phone call**
- Age: [mean age]
- Balance: [mean balance]
- Duration: [1.5x mean] (50% longer than average)
- Campaign: [mean]
- Previous: [mean]

Predicted probability: [X]

**Scenario 2: Young person with good balance**
- Age: 30
- Balance: 5000
- Duration: [mean]
- Campaign: 2
- Previous: 0

Predicted probability: [X]

## 12. Conclusion and Limitations

**Main findings:**
- Duration of phone call is the biggest predictor - longer calls = more subscriptions
- Account balance has a smaller positive effect
- Age and campaign stuff doesn't matter as much

**What this means:**
Quality of the conversation matters more than quantity of contacts. Banks should focus on having good conversations rather than just calling people more times.

**Limitations:**
- Using linear regression on binary data isn't ideal - logistic regression would be better
- Lots of variation still unexplained (R² = [X]) - there are other factors we're not capturing
- Duration might be backwards causality - maybe people who are interested talk longer, not that talking longer makes them interested
- Data is from 2008-2010 in Portugal - might not apply now or elsewhere
- We're missing other important stuff like job, education, economic conditions

**Future work:**
- Try logistic regression instead
- Use the enhanced dataset with economic indicators
- Look at interactions between variables
- Check if results change over time

## References

Moro, S., Laureano, R., & Cortez, P. (2011). Using Data Mining for Bank Direct Marketing: An Application of the CRISP-DM Methodology. *Proceedings of the European Simulation and Modelling Conference - ESM'2011*, pp. 117-121.
