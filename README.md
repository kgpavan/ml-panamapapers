# MarkLogic Panama Papers 

Provides an exploratory search + semantics application to help bootstrap your knowledge of using MarkLogic + Semantics.

## Getting Started

Running the app requires the following:
* MarkLogic 8+
* Ruby Version (1.9.3+)
* MarkLogic Content Pump (https://developer.marklogic.com/products/mlcp)


## Installing Application
```sparql
> git clone https://github.com/nativelogix/ml-panamapapers.git
> cd ml-panamapapers
> ./ml bootstrap local
> ./ml deploy modules local
```

## Loading Data
* Unzip the `data.zip` file into `{project-root}/data`
* The `run.bat` file has all the necessary mlcp commands to load the content. An .sh version will come shortly, but should be enough to get started.
* Make sure you set your credentials to match your admin or ml-panama-paper user credentials.


## Some useful queries

The following are queries that can provide some useful insight into the dataset.

Count properties(predicates) in dataset
```
## Count properties(predicates) in dataset
SELECT ?p (COUNT(?p) as ?count)
WHERE {
  ?s ?p ?o
}
GROUP BY ?p
ORDER BY DESC(?count)
LIMIT 200
```
Get a list of types of entities and their count

```
## Count Entities by Type
PREFIX pp: <http://panamapapers.icij.org/>
PREFIX rdf: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?o (COUNT(?o) as ?type)
WHERE {?s rdf:type ?o}
GROUP BY ?o
```

Select the top countries where entities do business

```
#Top Countries group descending
PREFIX pp: <http://panamapapers.icij.org/>
PREFIX rdf: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?ftype ?country (count(?ftype) as ?count) 
WHERE {
  ?from rdf:type ?ftype .
  ?from (<registeredAddress>|<sameAsAddress>) ?to . 
  ?to rdf:type ?ttype FILTER(?ttype = pp:Address) .
  ?to pp:countries ?country
}
GROUP BY ?ftype ?country 
ORDER BY ?ftype DESC(?count)
LIMIT 10
```
