# ppml_simulation version 1

This script estimates a gravity model of international trade based on a setting file, setup.csv. In the setup file, one can choose his or her desired number of simulations, *s*, number of countries, *c*, the number of time periods, *t*, and the true parameters, *b*. This script allows multiple settings. Please save your desired settings by rows.

## The estimated model

*export* = exp(*Xb* + *exporter time fixed effects* + *importer time fixed effects* + *e*).

To note that, there is no constant term in this model, and the importer dummies of one designed country are dropped for every year. For example, if the data include three countries and two years, there will be six (3 x 2 = 6) exporter dummies and four (3 x 2 - 2 = 4) importer dummies. The exporter and importer fixed effects, and the error term, *e*, are generated from a standard normal distribution, *N*(0, 1). The exogenous control variable, *X*, follows a uniform distribution with  from negative one to positive one, *u*(-1, 1).
