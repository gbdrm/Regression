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

Basic stats for the variables:

| Variable | Mean | Std Dev | Min | Max |
|----------|------|---------|-----|-----|
| Subscription | 0.117 | 0.321 | 0 | 1 |
| Age | 40.9 | 10.6 | 18 | 95 |
| Balance | 1362 | 3045 | -8019 | 102127 |
| Duration | 258 | 258 | 0 | 4918 |
| Campaign | 2.76 | 3.10 | 1 | 63 |
| Previous | 0.58 | 2.30 | 0 | 275 |

The subscription rate is only 11.7% - most people say no. Balance and duration have a lot of variation - some people have negative balances (overdrafts), others have over 100k. Contact duration varies a lot too, from 0 seconds to over an hour.

## 5. Model Specification

Running a multiple regression:

**Subscription = β₀ + β₁(Age) + β₂(Balance) + β₃(Duration) + β₄(Campaign) + β₅(Previous) + ε**

Where:
- Y = Subscription (0 or 1)
- X's = Age, Balance, Duration, Campaign, Previous

Using basic OLS regression with lm() in R.

## 6. Regression Results and Coefficient Interpretation

| Variable | Coefficient | Std Error | t-value | p-value | Significance |
|----------|------------|-----------|---------|---------|--------------|
| Intercept | -0.0401 | 0.00584 | -6.87 | < 0.001 | *** |
| Age | 0.000699 | 0.000131 | 5.36 | < 0.001 | *** |
| Balance | 0.00000423 | 0.000000455 | 9.30 | < 0.001 | *** |
| Duration | 0.000487 | 0.00000538 | 90.7 | < 0.001 | *** |
| Campaign | -0.00381 | 0.000447 | -8.51 | < 0.001 | *** |
| Previous | 0.0127 | 0.000599 | 21.2 | < 0.001 | *** |

What this actually means:
- **Duration** - huge effect. Each extra second of contact time increases subscription probability by 0.0487 percentage points. So a 100-second longer call increases probability by about 4.9%
- **Previous** - surprisingly important! Each previous contact increases subscription probability by 1.27 percentage points
- **Campaign** - negative effect! More contacts in this campaign actually decreases probability. Each additional contact reduces probability by 0.38%
- **Balance** - tiny but significant. Each additional euro increases probability by 0.000423%
- **Age** - very small effect. Each year older increases probability by 0.07%

## 7. Statistical Significance

Looking at p-values (α = 0.05):

All variables are highly significant (p < 0.001)! This is actually surprising - we expected only duration and balance to matter, but everything came out significant.

- **Duration**: p < 2e-16 (extremely significant)
- **Previous**: p < 2e-16 (extremely significant)
- **Campaign**: p < 2e-16 (significant, but negative)
- **Balance**: p < 2e-16 (significant)
- **Age**: p = 8.38e-08 (significant)

With 45,211 observations, even small effects can be statistically significant. The real question is which ones matter practically - duration and previous contacts seem to have the biggest actual impact.

## 8. Confidence Intervals

95% confidence intervals for the coefficients:

| Variable | Lower CI | Upper CI | Includes Zero? |
|----------|----------|----------|----------------|
| Age | 0.000444 | 0.000955 | No |
| Balance | 0.00000334 | 0.00000513 | No |
| Duration | 0.000477 | 0.000498 | No |
| Campaign | -0.00468 | -0.00293 | No |
| Previous | 0.0115 | 0.0139 | No |

None of the intervals include zero, which confirms all variables are significant. The tightest interval is duration (very precise estimate), while campaign is also pretty tight but negative.

## 9. Coefficient of Determination (R²)

R² = 0.168
Adjusted R² = 0.168

This means about 16.8% of the variation in subscriptions is explained by these variables. That's not great - 83% of the variation is still unexplained. There's a lot going on with subscription decisions that we're not capturing with just these 5 variables.

Since we're using regular regression on a binary outcome (0/1), the R² isn't perfect but gives a general idea of fit. Logistic regression would be better here but this works for now. The low R² suggests we're missing important factors - probably things like job type, education, economic conditions, or the actual content of the conversations.

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
- Age: 41 years
- Balance: €1362
- Duration: 387 seconds (50% longer than average)
- Campaign: 2.76 contacts
- Previous: 0.58 contacts

Predicted probability: **18.0%** (95% CI: -39.5% to 75.5%)

**Scenario 2: Young person with good balance**
- Age: 30 years
- Balance: €5000
- Duration: 258 seconds (average)
- Campaign: 2 contacts
- Previous: 0 contacts

Predicted probability: **12.0%** (95% CI: -45.4% to 69.5%)

The longer contact duration in scenario 1 boosts the probability from 12% to 18% - a 50% increase. But the confidence intervals are really wide and go below zero (which doesn't make sense for a probability), which shows the limitations of using linear regression for binary outcomes.

## 12. Conclusion and Limitations

**Main findings:**
- Duration of phone call is by far the biggest predictor - longer calls = more subscriptions
- Previous contact history matters a lot (contrary to what we expected)
- Campaign contacts have a negative effect - calling people more times in the same campaign actually hurts
- Account balance and age have small but significant effects
- Overall, we only explain 16.8% of the variation - lots of other factors matter

**What this means:**
Quality beats quantity. Banks should focus on having meaningful conversations rather than bombarding people with calls. The negative campaign effect is interesting - maybe people get annoyed if you call them too many times. Previous contacts help, but current campaign contacts hurt - suggests that building relationships over time works better than aggressive short-term campaigns.

**Limitations:**
- Using linear regression on binary data isn't ideal - logistic regression would be better (we get nonsensical predictions below 0%)
- Lots of variation still unexplained (R² = 0.168) - we're missing important factors
- Duration might be backwards causality - maybe people who are interested talk longer, not that talking longer makes them interested
- Data is from 2008-2010 in Portugal during the financial crisis - might not apply now or elsewhere
- We're missing other important stuff like job, education, economic conditions, and what's actually said in the conversations

**Future work:**
- Try logistic regression instead
- Use the enhanced dataset with economic indicators
- Look at interactions between variables
- Check if results change over time

## References

Moro, S., Laureano, R., & Cortez, P. (2011). Using Data Mining for Bank Direct Marketing: An Application of the CRISP-DM Methodology. *Proceedings of the European Simulation and Modelling Conference - ESM'2011*, pp. 117-121.
