# Make SQL from Shapefiles downloaded from City data portal
# using shp2pgsql
shp2pgsql -c -D -s 4326 -I shp/Zip_Codes.shp > zips.sql
shp2pgsql -c -D -s 3435 -I shp/CommAreas.shp > comm_areas.sql

# load that junk into PostgreSQL + PostGIS
psql -d chicago_geographies -f comm_areas.sql
psql -d chicago_geographies -f zips.sql

# Query to get adjacent community areas and output to csv
# Run from psql shell
\copy (select a.area_numbe, b.area_numbe, a.community, b.community from commareas as a join commareas as b on ST_Touches(a.geom, b.geom) order by a.community) to 'comms-to-comms.csv' with csv;

\copy (select a.zip, b.zip from zip_codes as a join zip_codes as b on ST_Intersects(a.geom, b.geom) order by a.zip) to 'zips-to-zips.csv' with csv;

# Query to get adjacent zipcodes and output to csv
\copy (select commareas.area_numbe as area_number, zip_codes.zip as zip, commareas.community as name from commareas join zip_codes on ST_Intersects(ST_Transform(commareas.geom, 4326), zip_codes.geom) order by area_number) to 'comms-to-zips.csv' with csv;