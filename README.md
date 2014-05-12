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

The interaction with Mongo is handled using the [Mongoid](http://mongoid.org/en/mongoid/index.html) object-document-mapper. It offers a simple API for interacting with mongo that is similar to ActiveRecord.

This API is used to:

* declare the types of fields associated with the model objects
* identify required fields, e.g. `validates`
* define relationships, e.g. `belongs_to`, `has_many`
* add validation

## Observation Validation

Some [custom validation](https://github.com/ONSdigital/ons_data_models/blob/master/app/models/observation.rb#L10) is performed on Observation objects when they are added to the database.

An Observation is a set of key-value pairs. They legal keys for an Observation are the set of names of the dimensions, attributes and measures defined on its related Dataset. It is an error to add an Observation that uses a property that is not defined in the structure of the Dataset.

## Dataset Slicing

A Dataset has a set of Observations. This set can be queried (or "sliced") to create a sub-set, e.g. a time-series for a specific measure and set of dimensions.

The code for querying datasets used in the API is in the `[Dataset.slice](https://github.com/ONSdigital/ons_data_models/blob/master/app/models/dataset.rb#L104)` method.

The method accepts a query object which is used to [construct a Mongo query](http://mongoid.org/en/mongoid/docs/querying.html). The query object consists of keys-value pairs. The keys are the names of dimensions, measures or attributes that will be matched in the query.

Some pre-processing may be carried out when querying dimensions. Dimensions are associated with hierarchical concept schemes, e.g. a hierarchy of products or of dates (e.g. year -> quarter -> month). 

* If the value is a wildcard ("`*`") then the query will match any of values from the lowest levels in the hierarchy. E.g. for the date dimension this will be all months
* If the value includes a path (e.g. "`2010/*`") then the query will match any values below the specified entry in the hierarchy. E.g. `2010/*` will match everything below `2010`. The `value_type` parameter to the `slice` method is used to filter the results further, e.g to include only quarters or only months
* If the value isn't either of the above, then observations must have exactly that value for the specified dimension

This gives a way to construct queries that use the structure of a dataset, allowing different levels of detail to be extracted.

The `date` dimension is also special cased. This is currently hard-coded but a complete implementation would handle this better.

If no date dimension is specified then the query is extended to only match the most granular values, e.g. all months. This provides a default scope for retrieving time series data.