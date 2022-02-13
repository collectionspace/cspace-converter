# cspace-converter

[![Build Status](https://travis-ci.com/collectionspace/cspace-converter.svg?branch=master)](https://travis-ci.com/collectionspace/cspace-converter) [![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)

**This project is no longer maintained and has been superceded by the [CollectionSpace CSV Importer](https://github.com/collectionspace/collectionspace-csv-importer).**

Migrate data to CollectionSpace.

## Getting Started

The converter tool is a [Ruby on Rails](https://rubyonrails.org/) application.
The database backend is [MongoDB](https://www.mongodb.com/) (v3.2).

For deployments there is a [Docker image](https://hub.docker.com/repository/docker/collectionspace/cspace-converter) and [docs](docs/DEPLOYMENT.md) available.

## Running the Converter locally

To run the converter locally install Ruby and bundler then run:

```bash
bundle install
```

See `.ruby-version` for the recommended version of Ruby.

## Configuration

There is a default `.env` file that provides example configuration. Override it
by creating a `.env.local` file with custom settings.

```bash
# DEVELOPMENT .env.local
CSPACE_CONVERTER_BASE_URI=https://core.dev.collectionspace.org/cspace-services
CSPACE_CONVERTER_DB_NAME=nightly_core
CSPACE_CONVERTER_DOMAIN=core.collectionspace.org
CSPACE_CONVERTER_MODULE=Core
CSPACE_CONVERTER_USERNAME=admin@core.collectionspace.org
CSPACE_CONVERTER_PASSWORD=Administrator
```

The `CSPACE_CONVERTER_BASE_URI` variable must point to an _available_ ColletionSpace
Services Layer backend.

## Start the MongoDB Server

Run Mongo using Docker:

```bash
docker run --name mongo -d -p 27017:27017 mongo:3.2
```

You should be able to access MongDB on `http://localhost:27017`.

If you prefer to run Mongo traditionally follow the installation docs online.

You can dump and restore the database with Mongo Tools:

```bash
sudo apt-get install mongo-tools # ubuntu
mongodump --archive=data/dump/cspace_converter_development.gz
mongorestore --archive=data/dump/cspace_converter_development.gz
```

[Robo3T](https://robomongo.org/download) is recommended for a GUI client.

## Setup CSV Data to be Imported

Before the tool can import CSV data into CollectionSpace, it first "stages" the
data from the CSV files into the MongoDB database.

Create a data directory and add the CSV files. For example:

```txt
data/core/
├── mymuseum_cataloging.csv
```

Note that where you save the CSV files is irrelevant. You can browse to any file on your computer using the Web UI, and provide a full path via the CLI.

In the `data` directory of this repo, there are sample data files available for testing for each supported
Collectionspace profile. These files can also be used as templates for creating CSV data to import.

### To start from scratch or start over:

```bash
./reset.sh
```

## Converter Tool Web UI

```bash
./bin/rails s
```

Once started, visit http://localhost:3000 with a web browser.

To execute jobs created using the UI run this command:

```bash
./bin/delayed_job run --exit-on-complete
```

## Converter Tool CLI

### Stage the data to MongoDB

The general format for the command is:

```bash
./import.sh [FILE] [BATCH] [PROFILE]
```

- `FILE`: path to the import file
- `BATCH`: import batch label (for future reference)
- `PROFILE`: profile key from config (`config.yml` registered_profiles)

For example:

```bash
./import.sh data/core/cataloging_core_excerpt.csv cataloging1 cataloging
```

Then to transfer:

```bash
./remote.sh transfer CollectionObject cataloging1
./remote.sh delete CollectionObject cataloging1
```

## Useful commands

### Making api requests to the remote CollectionSpace instance

```bash
# provides a list of records
./bin/rake remote:client:get[collectionobjects]

# get an object record
./bin/rake remote:client:get[collectionobjects/$CSID]

# get list of concept authorities
./bin/rake remote:client:get[conceptauthorities]

# get a concept authority record
./bin/rake remote:client:get[conceptauthorities/$AUTHORITY_CSID/items/$TERM_CSID]
```

### Using the console

```bash
./bin/rails c
```

``` ruby
# See first existing DataObject
puts DataObject.first.inspect

# Get CSID from cached collectionObject
# The second parameter is the Identification number from the record.
CollectionSpaceObject.find_csid('CollectionObject', 'A 291/000004')

# Get CSID from remote collectionObject
# The string in the second line is the Identification number from the record.
# This will return nil unless there is ONE matching collectionObject found
service = Lookup.record_class('CollectionObject').service(nil)
RemoteActionService.find_item_csid(service, 'A 1/000261')
# Or, to do this with an existing CollectionSpaceObject record
obj = CollectionSpaceObject.where(identifier: '123456').first
RemoteActionService.new(obj).ping
obj.csid
```

### Clearing out data

```bash
./bin/rake db:nuke
```

Warning: this deletes all data, including failed jobs.

### Running tests

```bash
./bin/rake spec # requires Mongo
```

## License

The project is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

---
