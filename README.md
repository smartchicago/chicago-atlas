# Chicago Health Atlas

The Chicago Health Atlas is a place where you can view citywide information about health trends and take action near you to improve your own health.

## Installation

Install the [Heroku Toolbelt](https://toolbelt.heroku.com/) - required for deployment and importing Purple Binder data

``` bash
git clone git@github.com:smartchicago/chicago-atlas.git
cd chicago-atlas
gem install bundler
bundle install
cp config/database.yml.example config/database.yml
rake db:setup
```

## Download and import data

The Chicago Health Atlas uses data from the [Chicago Data Portal](http://data.cityofchicago.org), the US Census, CHITREC, the [Chicago Tribune Boundary Service](http://boundaries.tribapps.com/), [Purple Binder](http://purplebinder.com), and several other sources. Chicago and Purple Binder data are downloaded directly from APIs, while others are loaded directly from saved copies in the [import directory](https://github.com/smartchicago/chicago-atlas/tree/master/db/import) of this repository.


### All geographies, statistics and resources
```bash
rake db:import:all
```

### Just statistics
```bash
rake db:import:stats
```

### Individual datasets
```bash
rake db:import:geography:community_areas
rake db:import:geography:zip_codes
rake db:import:census:population
rake db:import:chicago:crime
rake db:import:chicago:dph
rake db:import:chitrec:all
rake db:import:purple_binder:all
```

### Refreshing saved copies

Chicago community areas
```bash
rake db:import:geography:community_areas_download
```

Purple Binder
To import the [Purple Binder](http://purplebinder.com) data, you will need an API key from their [developers page](http://app.purplebinder.com/developers).

```bash
curl http://app.purplebinder.com/api/programs   -H 'Authorization: Token token="{purple_binder_token}"' > db/import/pb_programs.json
```

## Running locally

``` bash
bundle exec unicorn
```

navigate to http://localhost:8080/

## Dependencies

* Rails 3.2.17
* Ruby 1.9.3-p194
* Haml
* Heroku
* Twitter Bootstrap
* Leaflet

## Team

* [Dan O'Neil](mailto:doneil@cct.org): runs the project for the [Smart Chicago Collaborative](http://www.smartchicagocollaborative.org/)
* Chicago Department of Public Health: many stakeholders publishing and interpreting data
* Purple Binder: provider of all location data for health resources.
* Derek Eder: lead developer; owner of Data Made, which is a contractor for the Smart Chicago Collaborative


## Errors / Bugs

If something is not behaving intuitively, it is a bug, and should be reported.
Report it here: https://github.com/smartchicago/chicago-atlas/issues

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Commit, do not mess with rakefile, version, or history.
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2013 DataMade. Released under the MIT License.
