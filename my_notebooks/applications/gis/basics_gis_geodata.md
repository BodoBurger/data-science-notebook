---
title: Basics GIS / geodata
date: 2024-04-15 
---

## Was sind GIS?

- Geographische Informationssysteme
    -Systeme zur Erfassung, Bearbeitung, Organisation, Analyse und Präsentation räumlicher Daten --> umfasst Hardware, Software und Daten
- Einsatz im Marketing, Logistik, Ressourcenmanagement, Stadtplanung, Bau eines 5G-Mobilfunknetzes uvm.
- Links: https://de.wikipedia.org/wiki/Geoinformationssystem


## Was ist das besondere an Geodaten?

- Kombination tabellarischer Daten und Geometrien
- Arten von Geometrien
    - Punkte (z.B. eine Geokoordinate)
    - Linie (z.B. Straßenabschnitt)
    - Polygon (z.B. Gebäudeumriss)
    - Collections (Sammlung mehrerer Geometrien)
- OpenStreetMap Elemente
    - Nodes
    - Ways
    - Relations
- Links
    - https://shapely.readthedocs.io/en/stable/geometry.htmlh
    - https://wiki.openstreetmap.org/wiki/Elements


## Software

- ArcGis (Esri)
- QGIS: Open-Source-Alternative to ArcGis
- GeoPandas
    - GeoDataFrame combines Pandas DataFrame and Shapely geometries
- Links
    - https://www.qgis.org
    - https://geopandas.org


## Datenformate

- Shapefile (.shp)
    -ESRI
    -Mehrere Dateien notwendig; viele Einschränkungen
- GeoPackage (.gpkg)
- GeoJSON
- Csv
    - Kann Geometrien in WKT-Format enthalten
- Datenbanken bei größeren Datenmengen
    - PostGIS (PostgreSQL Erweiterung)
    - Oracle SDO (Oracle DB Erweiterung)
    - ArcGIS SDE (Spatial Data Engine von Esri)
- Links
    - https://en.wikipedia.org/wiki/Well-known_text_representation_of_geometry
    - http://switchfromshapefile.org/
    - https://postgis.net/
