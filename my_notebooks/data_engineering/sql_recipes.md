# SQL recipes

## Create copy of a table

`````{tab-set}
````{tab-item} Oracle

```{code-block} sql
CREATE TABLE new_table AS
SELECT * FROM existing_table;
```

````

````{tab-item} PostgreSQL

```{code-block} sql
CREATE TABLE new_table AS
SELECT * FROM existing_table;
```

````
`````
