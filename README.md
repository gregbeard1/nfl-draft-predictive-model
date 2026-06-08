# Predicting NFL Success from Combine Metrics

## Overview
Can NFL Combine performance predict future NFL success? This project uses historical combine and draft data to develop predictive models that estimate a player's future NFL value. The goal was to identify which combine metrics are most predictive of career success and determine which modeling approach performs best.

## Research Questions
- Which variables best predict NFL success?
- Are NFL Combine metrics actually important?
- Which combine drills are overvalued or undervalued?
- Which predictive model provides the best performance?

## Data Sources
- **NFL Combine Data (Kaggle)**
  - Height
  - Weight
  - 40-yard dash
  - Vertical jump
  - Bench press
  - Broad jump
  - 3-cone drill
  - 20-yard shuttle
  - Position

- **Pro Football Reference**
  - Draft round
  - Draft pick
  - Draft year
  - Weighted Approximate Value (AV)

Weighted AV was used as the measure of NFL career success.

## Methodology
The following models were developed and compared:

- Ordinary Least Squares (OLS) Regression
- LASSO Regression
- Ridge Regression
- Random Forest

Models were evaluated using repeated 10-fold cross-validation (5 repeats).

Performance metrics:
- RMSE (Root Mean Squared Error)
- R² (Coefficient of Determination)

## Results

| Model | RMSE | R² |
|---------|---------|---------|
| OLS | 18.15 | 0.294 |
| LASSO | 19.88 | 0.242 |
| Ridge | 19.87 | 0.241 |
| Random Forest | 17.63 | 0.334 |

Random Forest produced the strongest predictive performance.

## Key Findings
- The 40-yard dash consistently emerged as an important predictor of future success.
- The 3-cone drill was one of the strongest combine-related indicators across multiple models.
- Draft position remained a powerful predictor, suggesting NFL teams possess valuable information beyond athletic testing.
- Bench press, vertical jump, and broad jump contributed less predictive value than expected.


## Skills Demonstrated
- Predictive Modeling
- Machine Learning
- Cross-Validation
- Feature Selection
- Sports Analytics
- R Programming
- Statistical Analysis

## Related Portfolio Entry
A more detailed discussion of this project, including visualizations and business implications, can be found on my personal portfolio website.
