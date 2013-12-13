/* Make SQL from Shapefiles downloaded from City data portal
** using shp2pgsql */
shp2pgsql -c -D -s 3435 -I Zip_Codes.shp > zips.sql
shp2pgsql -c -D -s 3435 -I CommAreas.shp > comm_areas.sql

/* load that junk into PostgreSQL + PostGIS */
psql -d database_name -f comm_areas.sql
psql -d database_name -f zips.sql

/* Query to get adjacent community areas and output to csv */
/* Run from psql shell */
\copy (select a.area_numbe, b.area_numbe, a.community, b.community from commareas as a join commareas as b on ST_Touches(a.the_geom, b.the_geom) order by a.community) to '/tmp/comms-to-zips.csv' with csv;

/* Query to get adjacent zipcodes and output to csv */
\copy (select commareas.area_numbe as area_number, commareas.community as name, zip_codes.zip as zip from commareas join zip_codes on ST_Intersects(commareas.the_geom, zip_codes.the_geom) order by area_number) to '/tmp/comms_to_zips.csv' with csv;
