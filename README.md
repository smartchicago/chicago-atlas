# Chicago Health Atlas

The Chicago Health Atlas is a place where you can view citywide information about health trends and take action near you to improve your own health.

## Installation

Install the [Heroku Toolbelt](https://toolbelt.heroku.com/) - required for deployment and importing Purple Binder data

``` bash
git clone git@github.com:smartchicago/chicago-atlas.git
cd chicago-atlas
gem install bundler
bundle install
rake db:setup
rake db:import:all
```

To import the [Purple Binder](purplebinder.com) data, you will need an API key from their [developers page](http://app.purplebinder.com/developers). The import task requires `foreman` which is included in the [Heroku Toolbelt](https://toolbelt.heroku.com/).


```bash
cp .env.example .env
```

Paste your Purple Binder API key in the `.env` file.

```bash
foreman run rake db:import:purple_binder
```

Populate the config.yml file with config settings. Values can be found via `heroku config`

``` bash
bundle exec unicorn
```

navigate to http://localhost:8080/

## Dependencies

* Rails 3.2.13
* Ruby 1.9.3-p194
* Haml
* Heroku
* Twitter Bootstrap
* Leaflet

## Team

* [Derek Eder](mailto:derek.eder+git@gmail.com)
* [Aaron U. Salmon](mailto:aaronusalmon@gmail.com)
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
