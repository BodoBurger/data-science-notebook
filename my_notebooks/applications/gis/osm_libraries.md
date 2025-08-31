---
title: OpenStreetMap Daten und Libraries
date: 2024-05-01
lastmod: 2025-08-31
tags: ["OSM"]
math: true
---

## OSM Wiki

Software libraries: https://wiki.openstreetmap.org/wiki/Software_libraries


## Python Libraries


## geopy

https://geopy.readthedocs.io/

    geopy is a Python client for several popular geocoding web services

Geocode addresses using Nomination or with other geocoding services.

 
### osm2geojson

https://github.com/aspectumapp/osm2geojson
    
If you want to convert OSM xml or Overpass json/xml to Geojson you can import this lib and use one of 4 methods:

    json2shapes(dict json_from_overpass) - to convert Overpass json to *Shape-objects
    xml2shapes(str xml_from_osm) - to convert OSM xml or Overpass xml to *Shape-objects
    json2geojson(dict json_from_overpass) - to convert Overpass json to Geojson
    xml2geojson(str xml_from_osm) - to convert OSM xml or Overpass xml to Geojson

Does not seem to be actively developed.

 
### OSMnx

https://osmnx.readthedocs.io

    OSMnx is a Python package to easily download, model, analyze, and visualize street networks and other geospatial features from OpenStreetMap

Uses Nominatim API to download OSM elements, slower than Overpass API.

 
### Overpy

https://python-overpy.readthedocs.io

    Python Wrapper to access the Overpass API
    
Is there any advantage to query the API directly using `requests`?


### Pyrosm

https://pyrosm.readthedocs.io

- Python library for reading OpenStreetMap from Protocolbuffer Binary Format -files (*.osm.pbf) into Geopandas GeoDataFrames
- Routing functionality
- This tutorial that shows how to construct simple shortest path routing between selected source and destination addresses using NetworkX and OSMnx: https://pyrosm.readthedocs.io/en/latest/graphs.html#find-shortest-path-with-pyrosm-networkx-osmnx
