#Spotlight 🔦
**A kickass dashboard for devshops**

[![Build Status](https://travis-ci.com/neo/spotlight.svg?token=32PipsqvKVziGaUwVvvT)](https://travis-ci.com/neo/spotlight)
[![Code Climate](https://codeclimate.com/repos/568b75839848c5568e002bc6/badges/fa755cbb5f59a5f15936/gpa.svg)](https://codeclimate.com/repos/568b75839848c5568e002bc6/feed)

## Synopsis

Spotlight is a simple dashboard for your devshop that: 

 * Allows people to easily create a dashboard and manage widgets from a predefined set of widgets. 
 * Is wrapped in a container that can easily be downloaded and installed on any environment.
 * Lets you view Continuous Integration build status for the various projects is the primary goal. 
 * Lets you add new widgets from a list of predefined ones, or create your own.


## Motivation

Software developers are increasingly adopting agile and lean approaches to the software development lifecycle. One key component for agile software processes is that of Continuous Integration (CI). With the ubiquity of inexpensive hardware like flat panel displays and Raspberry Pis (single board computer), the DIY approach to building custom information displays is gaining increasing appeal.

We belive there is a need for a simple, hassle free approach to CI monitors.

## Installation

[todo]

## Tests

[todo]


## Docker

1. Install [Docker Toolbox](https://docs.docker.com/mac/step_one/).
2. Replace `config/database.yml` with a copy of `config/database-docker.yml`.
3. Run the following commands:

  ```
docker-compose build
docker-compose run --rm web rake db:create
docker-compose run --rm web rake db:create
docker-compose up
```

4. Access to app via the container IP address (e.g. `http://192.168.99.100:3030`).

  *You can find out the IP address of the docker machine by running `docker-machine ls`.*

## Contributors
[todo]

## License

**The MIT License (MIT)**
Copyright (c) 2015 Neo Innovation

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
