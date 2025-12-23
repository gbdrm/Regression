# Multiple Regression Analysis of Bank Marketing Data

## 1. Research Question

We're looking at what makes customers more likely to subscribe to a term deposit when the bank calls them. Specifically, we want to see if variables like age, account balance, call duration, number of contacts, and previous contact history can predict subscription outcomes.

## 2. Dataset Description

We used the Bank Marketing dataset from UC Irvine Machine Learning Repository. The data comes from phone-based marketing campaigns run by a Portuguese bank between May 2008 and November 2010.

Dataset specs:
- 45,211 client contacts
- 17 variables total (we're using 6)
- Outcome: whether they subscribed to a term deposit (yes/no)

## 3. Data Inspection and Cleaning

We loaded the full dataset in R and ran str() and summary() to check things out.

Cleaning steps:
- Loaded bank-full.csv (45,211 rows)
- Checked for missing values - none found in our variables
- Converted the yes/no outcome to 1/0 numeric
- Pulled out the 6 variables we need
- Final dataset had no missing data

## 4. Summary Statistics

| Variable | Mean | Std Dev | Min | Max |
|----------|------|---------|-----|-----|
| Subscription | 0.117 | 0.321 | 0 | 1 |
| Age | 40.9 | 10.6 | 18 | 95 |
| Balance | 1362 | 3045 | -8019 | 102127 |
| Duration | 258 | 258 | 0 | 4918 |
| Campaign | 2.76 | 3.10 | 1 | 63 |
| Previous | 0.58 | 2.30 | 0 | 275 |

Only 11.7% of people subscribed. Balance and duration have huge ranges - some people are in overdraft (negative balance), others have over 100k euros. Call duration goes from zero seconds up to over an hour.

## 5. Model Specification

**Subscription = β₀ + β₁(Age) + β₂(Balance) + β₃(Duration) + β₄(Campaign) + β₅(Previous) + ε**

Where subscription is coded 0/1, and we're using OLS regression (lm() in R). Yeah, we know this isn't ideal for binary outcomes - more on that in limitations.

## 6. Regression Results and Interpretation

| Variable | Coefficient | Std Error | t-value | p-value | Significance |
|----------|------------|-----------|---------|---------|--------------|
| Intercept | -0.0401 | 0.00584 | -6.87 | < 0.001 | *** |
| Age | 0.000699 | 0.000131 | 5.36 | < 0.001 | *** |
| Balance | 0.00000423 | 0.000000455 | 9.30 | < 0.001 | *** |
| Duration | 0.000487 | 0.00000538 | 90.7 | < 0.001 | *** |
| Campaign | -0.00381 | 0.000447 | -8.51 | < 0.001 | *** |
| Previous | 0.0127 | 0.000599 | 21.2 | < 0.001 | *** |

The coefficients are small because we're predicting a probability between 0 and 1. Here's what matters:

**Duration** has the strongest effect by far. Each additional second increases subscription probability by about 0.05 percentage points. A 100-second longer call boosts probability by roughly 5%.

**Previous contacts** are surprisingly important - each prior contact adds 1.3 percentage points to subscription probability. This wasn't what we expected going in.

**Campaign** is negative, which is interesting. More contacts during *this* campaign actually hurt - each additional call reduces probability by 0.4%. Maybe people get annoyed.

**Balance** and **age** are both significant but the effects are tiny in practical terms.

## 7. Statistical Significance

All five predictors came back highly significant (p < 0.001). We honestly expected only duration and maybe balance to matter, so this was a bit surprising.

That said, with 45,211 observations, even very small effects show up as statistically significant. The question is whether they matter in practice. Duration and previous contacts seem to have the biggest real-world impact.

## 8. Confidence Intervals

95% CIs for the coefficients:

| Variable | Lower CI | Upper CI |
|----------|----------|----------|
| Age | 0.000444 | 0.000955 |
| Balance | 0.00000334 | 0.00000513 |
| Duration | 0.000477 | 0.000498 |
| Campaign | -0.00468 | -0.00293 |
| Previous | 0.0115 | 0.0139 |

None include zero, which lines up with everything being significant. Duration has the tightest interval - we're very confident about that estimate.

## 9. Model Fit (R²)

R² = 0.168
Adjusted R² = 0.168

So we're explaining about 17% of the variation in subscription outcomes. That's... not great. 83% of the variation is coming from stuff we're not measuring - probably things like job, education, the actual conversation content, economic conditions, etc.

The low R² makes sense given we only used 5 predictors and the outcome is complex human behavior. Also, R² can be misleading with binary outcomes anyway.

## 10. Residual Diagnostics

We generated the standard four diagnostic plots to check regression assumptions. See output/residual_plots.png for the plots.

Because we're using OLS on a binary outcome, the residuals look a bit weird (they're not going to be perfectly normal). But nothing looks terribly wrong. The plots suggest the model is reasonable enough for our purposes, even if it's not technically the right approach.

## 11. Predictions

We tested two scenarios:

**Scenario 1: Average client but longer call**
- Age: 41, Balance: €1362, Duration: 387 sec (1.5× average), Campaign: 2.76, Previous: 0.58
- Predicted probability: **18.0%** (95% CI: -39.5% to 75.5%)

**Scenario 2: Younger client with higher balance**
- Age: 30, Balance: €5000, Duration: 258 sec (average), Campaign: 2, Previous: 0
- Predicted probability: **12.0%** (95% CI: -45.4% to 69.5%)

The longer call time in scenario 1 pushes the predicted probability from 12% to 18%. But notice those confidence intervals - they go negative, which is nonsense for a probability. This is exactly the problem with using linear regression for binary outcomes.

## 12. Conclusion and Limitations

**Main takeaways:**

Duration matters most. Longer calls correlate strongly with subscriptions, though we can't say if longer calls *cause* subscriptions or if interested people just talk longer.

Previous contacts help, but contacts during the current campaign hurt. This suggests relationship-building over time works better than aggressive short-term tactics.

Balance and age matter statistically but probably don't matter much in practice given their tiny coefficients.

We only explain 17% of the variation. There's clearly a lot we're missing.

**Limitations:**

Linear regression on a binary outcome isn't the right tool - we get predictions outside [0,1] and weird residuals. Logistic regression would be better, but this gives us a rough idea of what matters.

Causality is unclear. Duration especially - maybe long calls lead to subscriptions, or maybe people who were already interested stay on the phone longer.

The data is from 2008-2010 Portugal during the financial crisis. Results might not hold in other contexts or time periods.

We're missing potentially important variables like occupation, education, economic indicators, and anything about what was actually said during the calls.

## References

Moro, S., Laureano, R., & Cortez, P. (2011). Using Data Mining for Bank Direct Marketing: An Application of the CRISP-DM Methodology. *Proceedings of the European Simulation and Modelling Conference - ESM'2011*, pp. 117-121.
