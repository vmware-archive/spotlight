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


## Running as Docker Container

1. Install [Docker Toolbox](https://docs.docker.com/mac/step_one/).

2. In your working folder, create a new file: `docker-compose.yml`

	```yaml
	db:
		image: postgres
	web:
		image: neosgspotlight/spotlight-rails
		command: bundle exec foreman start
		environment:
			- SECRET_KEY_BASE=<change_me!>
		ports:
			- "3030:3000"
		links:
			- db
```

	***Remember to add your own `SECRET_KEY_BASE`.***

3. Run the following command:

	```
docker-compose up
docker-compose run --rm web rake db:create db:migrate
```

4. Access to app via the container IP address (e.g. `http://192.168.99.100:3030`).

  *You can find out the IP address of the docker machine by running `docker-machine ls`.*

### Rebuilding the Docker container

1. Rebuild the local Docker image

	```
docker build -t spotlight-rails .
```

2. Check for the image ID

	```
➜  spotlight git:(docker) ✗ docker images
REPOSITORY                       TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
spotlight-rails                  latest              ba3dcc9b42b1        16 seconds ago      954.3 MB
```

3. Login to your Docker account (one time exercise) with `docker login`:

	```
➜  spotlight git:(docker) ✗ docker login
Username (miccheng):
WARNING: login credentials saved in /Users/miccheng/.docker/config.json
Login Succeeded
```

4. Tag the image

	```
docker tag ffb36fa443d8 neosgspotlight/spotlight-rails:latest
```

5. Push to Docker Hub

	```
docker push neosgspotlight/spotlight-rails
```

## Contributors
[todo]

## License

**The MIT License (MIT)**
Copyright (c) 2015 Neo Innovation

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
