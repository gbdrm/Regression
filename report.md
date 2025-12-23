# Multiple Regression Analysis of Bank Marketing Call Duration

## 1. Research Question

We're looking at what factors predict how long a marketing call lasts. Specifically, we want to see if customer characteristics (age, account balance), campaign variables (number of contacts, previous contact history), and whether they subscribe to the term deposit can explain call duration.

The research question is: What client and campaign characteristics are associated with longer phone call interactions during bank marketing campaigns?

## 2. Dataset Description

We used the Bank Marketing dataset from UC Irvine Machine Learning Repository. The data comes from phone-based marketing campaigns run by a Portuguese bank between May 2008 and November 2010.

Dataset specs:
- 45,211 client contacts
- 17 variables total (we're using 6)
- Outcome: call duration in seconds (continuous variable)

## 3. Data Inspection and Cleaning

We loaded the full dataset in R and ran str() and summary() to check things out.

Cleaning steps:
- Loaded bank-full.csv (45,211 rows)
- Checked for missing values - none found in our variables
- Converted the yes/no subscription outcome to 1/0 numeric (used as a predictor)
- Pulled out the 6 variables we need
- Final dataset had no missing data

## 4. Summary Statistics

| Variable | Mean | Std Dev | Min | Max |
|----------|------|---------|-----|-----|
| Duration | 258 | 258 | 0 | 4918 |
| Age | 40.9 | 10.6 | 18 | 95 |
| Balance | 1362 | 3045 | -8019 | 102127 |
| Campaign | 2.76 | 3.10 | 1 | 63 |
| Previous | 0.58 | 2.30 | 0 | 275 |
| Subscription | 0.117 | 0.321 | 0 | 1 |

Call duration has huge variation - from 0 seconds (hangups?) to over 80 minutes. The mean is 258 seconds (about 4.3 minutes). Balance also varies widely, with some people in overdraft and others with over 100k euros. Only 11.7% of clients subscribed.

## 5. Model Specification

**Duration = β₀ + β₁(Age) + β₂(Balance) + β₃(Campaign) + β₄(Previous) + β₅(Subscription) + ε**

Where duration is in seconds (continuous), and we're using OLS regression (lm() in R). This satisfies the assignment requirement for a continuous dependent variable.

## 6. Regression Results and Interpretation

| Variable | Coefficient | Std Error | t-value | p-value | Significance |
|----------|------------|-----------|---------|---------|--------------|
| Intercept | 250.8 | 4.55 | 55.1 | < 0.001 | *** |
| Age | -0.350 | 0.105 | -3.33 | 0.001 | *** |
| Balance | 0.000164 | 0.000367 | 0.448 | 0.654 | |
| Campaign | -4.73 | 0.359 | -13.2 | < 0.001 | *** |
| Previous | -4.18 | 0.484 | -8.64 | < 0.001 | *** |
| Subscription | 315.8 | 3.48 | 90.7 | < 0.001 | *** |

Here's what this tells us:

**Subscription** has by far the biggest effect. Calls where the client subscribes last about 316 seconds (5.3 minutes) longer than calls where they don't. This makes sense - if someone's interested and subscribing, the conversation takes longer to complete the transaction.

**Campaign** is negative - each additional contact in this campaign is associated with calls that are 4.7 seconds shorter. Maybe people get tired of being called and cut conversations short.

**Previous** contacts also show a negative effect - each prior contact is associated with 4.2 seconds shorter calls. This could mean familiar clients need less explanation.

**Age** has a small negative effect - older clients have slightly shorter calls (0.35 seconds per year). Not a huge effect but statistically significant.

**Balance** is not significant. Account balance doesn't seem to predict call duration.

## 7. Statistical Significance

Four out of five predictors are highly significant:

- **Subscription**: p < 0.001 (extremely significant)
- **Campaign**: p < 0.001 (extremely significant)
- **Previous**: p < 0.001 (extremely significant)
- **Age**: p = 0.001 (significant)
- **Balance**: p = 0.654 (not significant)

With 45,211 observations, we have a lot of statistical power, but balance still doesn't show any relationship with call duration.

## 8. Confidence Intervals

95% CIs for the coefficients:

| Variable | Lower CI | Upper CI |
|----------|----------|----------|
| Age | -0.556 | -0.144 |
| Balance | -0.000555 | 0.000883 |
| Campaign | -5.43 | -4.02 |
| Previous | -5.13 | -3.24 |
| Subscription | 308.96 | 322.61 |

The balance CI includes zero, confirming it's not significant. The subscription CI is very tight and far from zero - we're very confident about that effect.

## 9. Model Fit (R²)

R² = 0.160
Adjusted R² = 0.160

We're explaining about 16% of the variation in call duration. That's actually reasonable given we're only using 5 predictors. There's clearly a lot of variation in how long calls last that depends on things we're not measuring - probably the actual conversation content, agent skill, client interest level, etc.

The R² is similar to what we had before but now we're properly modeling a continuous outcome.

## 10. Residual Diagnostics

We generated the standard four diagnostic plots to check regression assumptions. See output/residual_plots.png for the plots.

The residuals look much better than in the binary outcome model - more normally distributed, though there's still some right skew (a few very long calls). The diagnostic plots suggest the linear regression assumptions are reasonably well met. There's some heteroscedasticity (variance increases with fitted values) but nothing too concerning.

## 11. Predictions

We tested two scenarios:

**Scenario 1: Average client who subscribes**
- Age: 41, Balance: €1362, Campaign: 2.76, Previous: 0.58, Subscription: Yes
- Predicted call duration: **537 seconds (9 minutes)** (95% CI: 74 to 1000 seconds)

**Scenario 2: Young client with high balance who doesn't subscribe**
- Age: 30, Balance: €5000, Campaign: 2, Previous: 0, Subscription: No
- Predicted call duration: **232 seconds (3.9 minutes)** (95% CI: -231 to 694 seconds)

The subscription makes a massive difference - calls with subscribers are predicted to last over twice as long (9 min vs 4 min). Note that scenario 2's CI goes negative, which doesn't make physical sense but is a limitation of the prediction interval.

## 12. Conclusion and Limitations

**Main takeaways:**

Whether someone subscribes is the dominant factor in call duration - subscriptions add over 5 minutes to call length on average. This makes intuitive sense.

More contacts (in current campaign or historically) are associated with shorter calls. This could mean repeat contacts are more efficient, or that annoyed customers cut calls short.

Age has a small negative effect - older clients have slightly shorter calls.

Balance doesn't matter for call duration.

**Limitations:**

The causality is unclear, especially for subscription. Do longer calls lead to subscriptions, or do subscriptions cause longer calls (because paperwork takes time)? Probably both.

We only explain 16% of variation. Call duration depends heavily on conversation content, agent behavior, client personality, and other unmeasured factors.

The data is from 2008-2010 Portugal. Phone marketing has changed a lot since then, especially with cell phones and caller ID.

Some very long calls (outliers) might be data errors or unusual situations that skew results.

**Why this approach is better:**

Unlike our previous binary outcome model, this uses a truly continuous dependent variable (duration in seconds), which properly satisfies the assignment requirements and makes linear regression appropriate. The results are more interpretable and the model assumptions are better met.

## References

Moro, S., Laureano, R., & Cortez, P. (2011). Using Data Mining for Bank Direct Marketing: An Application of the CRISP-DM Methodology. *Proceedings of the European Simulation and Modelling Conference - ESM'2011*, pp. 117-121.
