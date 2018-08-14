# ppml_simulation version 1

This script estimates a gravity model of international trade based on a setting file, setup.csv. In the setup file, one can choose his or her desired number of simulations, *s*, number of countries, *c*, the number of time periods, *t*, and the true parameters, *b*. This script allows multiple settings. Please save your desired settings by rows.

## The estimated model

*export* = exp(*Xb* + *exporter time fixed effects* + *importer time fixed effects* + *e*).

To note that, there is no constant term in this model. The exporter and importer fixed effects, and the error term, *e*, are generated from a standard normal distribution, *N*(0, 1). The exogenous control variable, *X*, follows a uniform distribution range from negative one to positive one, *u*(-1, 1).

## The setup file

- n_simulation: integer, the number of simulations.
- n_countries: integer, the number of countries.
- n_year: integer, the number of year.
- b: an array of true parameters countained in square brackets and separated by commas. For example, [1, -1].
- drop_importer_each_year: set to 1 to drop one importer fixed effect each year; set to 0 to drop only the first year importer fixed effect. For example, if the data include three countries and two years, there will be six (3 x 2 = 6) exporter dummies and four (3 x 2 - 2 = 4) importer dummies when drop_importer_each_year equals to 1.
