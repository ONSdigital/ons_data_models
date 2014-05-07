For background and context on this project see [https://github.com/ONSdigital/prototype-frontend](https://github.com/ONSdigital/prototype-frontend).

Open Statistics Prototype Data Models
=====================================

This project is a library of Ruby models used in both the [statistics API](https://github.com/ONSdigital/ons-data-api) and [data conversion code](https://github.com/ONSdigital/ons-poc-data).

By extracting this code into a common set of models it becomes easier to share them between projects.

## Data Model Summary

The data models are based on the conceptual model used in the [DataCube Vocabulary](http://www.w3.org/TR/vocab-data-cube/):

* Dimension -- the key dimensions to the statistical dataset, e.g. the reporting year or product type
* Measure -- the value being reported, e.g. price index
* Attribute -- qualifiers that apply to individual observations, e.g. whether data is provisionaly
* Concept Scheme -- controlled vocabulary used in dimensions, measures and attributes
* Observation -- an individual statistical observation, e.g. the price index for a specific product as measured in a specific month
* Dataset -- a collection of observations

These models are supplemented with a few additional objects:

* Release -- a statistical release, which may have several Datasets, e.g. the core statistical dataset and supplementary reference tables
* Series -- a set of Releases. E.g. the producer price index is a statistical series that has monthly releases.
* Contact -- statisticians

## Use of MongoDB

Rather than using a triple store the data is organised as JSON documents. There are individual documents for:

* Observations 
* Datasets
* Releases
* Series

Data on contacts, dimensions, measures, attributes and concept schemes are inlined into the relevant document. E.g. a dataset contains a descriptions of all of its dimensions, measures and attributes.

This structure simplifies querying and data access at the cost of denormalizing some of the data. For a production deployment it is expected that many of these elements would have their own JSON documents to make them easier to reference. Inlining might still be used as an optimisation to reduce the amount of joins.

## Validation

The majority of the validation is handled using simple model attributes, e.g. to indicate required fields or their types.

Some validation is done on Observations to check that they confirm to the expected structure of their containing Dataset, e.g. that their have the expected dimensions, measures, etc.
