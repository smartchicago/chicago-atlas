import os
import csv
import json
from operator import itemgetter
from itertools import groupby

def csv_mapper(fname):
    outp = {}
    with open(fname, 'rb') as f:
        rows = list(csv.reader(f))
    for row in rows:
        outp[row[0]] = []
    for row in rows:
        outp[row[0]].append(row[1])
    return outp

def map_comms(comm_zip, comm_comm):
    comm_areas = json.load(open('../community_areas.geojson', 'rb'))
    outp = open('comm_areas.geojson', 'wb')
    for feature in comm_areas['features']:
        feature['adjacent_zips'] = comm_zip[feature['external_id']]
        feature['adjacent_community_areas'] = comm_comm[feature['external_id']]
    outp.write(json.dumps(comm_areas, indent=4))

def map_zips(zip_zip):
    zip_areas = json.load(open('../zipcodes.geojson', 'rb'))
    outp = open('zips.geojson', 'wb')
    with open('comms-to-zips.csv', 'rb') as f:
        comm_zip = list(csv.reader(f))
    sorted_zips = sorted(comm_zip, key=itemgetter(1))
    zip_d = {}
    for k,g in groupby(sorted_zips, key=itemgetter(1)):
        zip_d[k] = list(g)
    for k,v in zip_d.items():
        zip_d[k] = []
        for row in v:
            zip_d[k].append(row[0])
    for feature in zip_areas['features']:
        zipcode = feature['properties']['ZIP']
        zip_list = zip_zip[zipcode]
        zip_list.remove(zipcode)
        try:
            feature['properties']['adjacent_zips'] = zip_zip[zipcode]
            feature['properties']['adjacent_community_areas'] = zip_d[zipcode]
        except KeyError:
            feature['properties']['adjacent_zips'] = []
            feature['properties']['adjacent_community_areas'] = []
    outp.write(json.dumps(zip_areas, indent=4))

if __name__ == '__main__':
    comm_zip = csv_mapper('comms-to-zips.csv')
    comm_comm = csv_mapper('comms-to-comms.csv')
    zip_zip = csv_mapper('zips-to-zips.csv')
    map_comms(comm_zip, comm_comm)
    map_zips(zip_zip)
