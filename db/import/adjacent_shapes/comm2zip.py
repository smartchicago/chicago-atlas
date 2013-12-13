import os
import csv
import json

def get_zip_mapper():
    outp = {}
    with open('comms_to_zips.csv', 'rb') as f:
        rows = list(csv.reader(f))
    for row in rows:
        outp[row[0]] = []
    for row in rows:
        outp[row[0]].append(row[2])
    return outp

def get_comm_mapper():
    outp = {}
    with open('comms-to-comms.csv', 'rb') as f:
        rows = list(csv.reader(f))
    for row in rows:
        outp[row[0]] = []
    for row in rows:
        outp[row[0]].append(row[1])
    return outp

def map_it(zip_mapper, comm_mapper):
    comm_areas = json.load(open('community_areas.geojson', 'rb'))
    outp = open('comm_areas.geojson', 'wb')
    for feature in comm_areas['features']:
        feature['adjacent_zips'] = zip_mapper[feature['external_id']]
        feature['adjacent_community_areas'] = comm_mapper[feature['external_id']]
    outp.write(json.dumps(comm_areas, indent=4))

if __name__ == '__main__':
    zip_mapper = get_zip_mapper()
    comm_mapper = get_comm_mapper()
    map_it(zip_mapper, comm_mapper)
