# Chicago Atlas

The Chicago Health Atlas is a place where you can view citywide information about health trends and take action near you to improve your own health.

## Installation

``` bash
git clone git@github.com:smartchicago/chicago-atlas.git
cd chicago-atlas
gem install bundler
bundle install
rake db:setup
rake db:import:all
```

Populate the config.yml file with config settings. Values can be found via `heroku config`

``` bash
bundle exec unicorn
```

navigate to http://localhost:8080/

## Dependencies

* Rails 3.2.12
* Ruby 1.9.3-p194
* Haml
* Heroku
* Twitter Bootstrap
* Leaflet

## Team

* [Derek Eder](mailto:derek.eder+git@gmail.com)
* Aaron Salmon
* [Dan O'Neil](mailto:doneil@cct.org)

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
