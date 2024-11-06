## Replication of statistics from data from paper Subjective likelihood and the construal level of future events: A replication study of Wakslak, Trope, Liberman, and Alony (2006)

Authors of this paper kindly published their [data in OSF](https://osf.io/5x8dp/?view_only=). They didn't publish their code. Here I wrote a script from scratch in R that calculates statistics for experiment 1 and 2 in their [paper](https://osf.io/preprints/psyarxiv/gd6ej).

## Main result: I do not know how to calculate Bayes Factor for experiment 2. Other statistics for experiment 1 and 2 seems to be ok. 

I can reproduce Bayes Factor from experiment 1. But cannot figure how to do it in experiment 2. 

I can also reproduce Figure 3 (see figures/exp2_crossing_plot.png).

Small discrepancies:

-   In experiment 1, they reported skewness= 2.49. I got 2.46 (in two ways).

-   In experiment 2, they are reporting reporting 90% CI as [.001, .015] and I am getting [0.000, 0.020]

It is weird because both of these numbers are from simple formulas, and are therefore numerically stable. Because the difference is tiny, it doesn't matter.

## Visualisation for experiment 1:

![](https://github.com/nadvornix/Calderon2020_statistical_replication/blob/main/figures/exp1histogram_DV_logtransformed_by_condition.png?raw=true)

## Visualisation for experiment 2

## ![](https://github.com/nadvornix/Calderon2020_statistical_replication/blob/main/figures/exp2_scatter_of_z-scores_with_marginals.png?raw=true)

Reproduction of Figure 3:

![](https://github.com/nadvornix/Calderon2020_statistical_replication/blob/main/figures/exp2_crossing_plot.png?raw=true)

## license: CC-BY

