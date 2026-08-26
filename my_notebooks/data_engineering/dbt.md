---
title: dbt (data build tool)
date: 2026-07
---

## What is dbt?

dbt is a framework for transforming data inside your data warehouse. Instead of writing Python scripts that:

1. Read data
1. Transform it
1. Write it back

You write SQL models, and dbt:

- manages dependencies
- executes models in the correct order
- tests your data
- generates documentation
- tracks lineage
- encourages modular design
- integrates with Git and CI/CD

Think of it as software engineering for SQL.

### What dbt does (and doesn't)

    API / CSV / ERP / CRM
            │
            ▼
    Ingestion (Fivetran, Airbyte, Python...)
            │
            ▼
    Raw tables
            │
            ▼
        dbt
            │
            ▼
    Clean analytics tables
            │
            ▼
    Power BI
    Tableau
    Looker
    Python ML

dbt is responsible for the transformation layer. It is not responsible for

- extracting data,
- scheduling jobs,
- dashboards,

although it integrates well with tools that do.

## The dbt mental model

A dbt SQL model is normally one .sql file containing one SELECT statement.
dbt compiles that statement and materializes the result as a database view, table, or another supported relation.
The SQL is executed by the underlying database—in this case, DuckDB.

The responsibilities are divided like this:

| Component    | Responsibility                                                                      |
| ------------ | ----------------------------------------------------------------------------------- |
| dbt Core     | Reads project files, compiles Jinja, determines dependencies, runs models and tests |
| `dbt-duckdb` | Connects dbt Core to DuckDB                                                         |
| DuckDB       | Executes SQL and stores the resulting tables and views                              |
| SQL models   | Describe the transformations                                                        |
| YAML files   | Describe configuration, tests, sources, and documentation                           |

DuckDB is an embedded analytical database. A database can be stored in one local .duckdb file, so no database server is needed.


## Learning dbt

Learning path with exercises: https://github.com/BodoBurger/learn_dbt
