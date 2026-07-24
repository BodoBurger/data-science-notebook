---
title: GIS and Geospatial Data Basics
description: A short introduction to geospatial data, coordinate systems, tools, and file formats.
date: 2024-04-15
tags:
  - GIS
  - geospatial
keywords:
  - GeoPandas
  - spatial data
  - coordinate reference systems
---

## What is GIS?

A geographic information system (GIS) captures, manages, analyzes, and presents spatial data. Common applications include logistics, urban planning, resource management, and telecommunications.


## Geospatial data

Geospatial data combines attributes with a location or shape.

### Vector data

- `Point`: location
- `LineString`: road or route
- `Polygon`: area or boundary
- Multi-geometries and `GeometryCollection`: groups of geometries

### Raster data

A raster is a grid of cells, used for imagery, elevation, and other continuous data.

### Coordinate reference systems

A coordinate reference system (CRS) relates coordinates to places on Earth.

- `EPSG:4326`: longitude and latitude
- Projected CRS: useful for measuring distance and area
- `set_crs()`: assigns a CRS; `to_crs()`: transforms coordinates

### OpenStreetMap

- Node: a point
- Way: an ordered list of nodes
- Relation: a group of nodes, ways, or relations


## Software

- Desktop: QGIS, ArcGIS Pro
- Python: GeoPandas, Shapely, Rasterio
- Conversion and processing: GDAL
- Databases: PostGIS, Oracle Spatial, ArcGIS enterprise geodatabase


## Storage formats

| Format | Data | Typical use |
| --- | --- | --- |
| GeoPackage (`.gpkg`) | Vector, tiled raster | Portable general-purpose storage |
| GeoJSON (`.geojson`) | Vector | Web and data exchange |
| GeoParquet (`.parquet`) | Vector | Columnar analytics |
| Shapefile (`.shp` and companion files) | Vector | Legacy interoperability |
| GeoTIFF / COG (`.tif`) | Raster | Imagery and elevation |
| PostGIS | Vector, raster | Large or shared datasets |

CSV files may store geometries as WKT, but usually lack standardized spatial metadata.


## Minimal GeoPandas example

```python
import geopandas as gpd

gdf = gpd.read_file("data.gpkg")
print(gdf.crs)
print(gdf.geometry.geom_type.value_counts())
```


## Further reading

- [GeoPandas introduction](https://geopandas.org/en/stable/getting_started/introduction.html)
- [GeoPandas projections](https://geopandas.org/en/stable/docs/user_guide/projections.html)
- [GDAL](https://gdal.org/en/stable/about.html)
- [OpenStreetMap elements](https://wiki.openstreetmap.org/wiki/Elements)
