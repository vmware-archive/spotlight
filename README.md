# Spotlight 🔦
**A kickass dashboard for devshops**

[![Build Status](https://travis-ci.org/pivotal-sg/spotlight.svg?branch=develop)](https://travis-ci.org/pivotal-sg/spotlight)
[![Code Climate](https://codeclimate.com/github/pivotal-sg/spotlight/badges/gpa.svg)](https://codeclimate.com/github/pivotal-sg/spotlight)

## Synopsis

Spotlight is a simple dashboard for your devshop that:

 * Allows people to easily create a dashboard and manage widgets from a predefined set of widgets.
 * Is wrapped in a container that can easily be downloaded and installed on any environment.
 * Lets you view Continuous Integration build status for the various projects is the primary goal.
 * Lets you add new widgets from a list of predefined ones, or create your own.

## Configuration instructions for Pivotal SG Spotlight

Please checkout our [wiki](https://github.com/pivotal-sg/spotlight/wiki) for configuration details

## Motivation

Software developers are increasingly adopting agile and lean approaches to the software development lifecycle. One key component for agile software processes is that of Continuous Integration (CI). With the ubiquity of inexpensive hardware like flat panel displays and Raspberry Pis (single board computer), the DIY approach to building custom information displays is gaining increasing appeal.

We believe there is a need for a simple, hassle free approach to CI monitors.

## Running the Spotlight Dashboard

We recommend installing the Spotlight dashboard as a Docker instance on the target machine.

### Installing

1. Install the [Docker Toolbox](https://docs.docker.com/mac/step_one/).

2. In your working folder, create a new file: `docker-compose.yml`

    ```yaml
	db:
	  image: postgres
	api:
	  image: pivotalsingapore/spotlight-rails
	  command: bin/rails server
	  env_file: docker_env
	  links:
	    - db
	web:
	  image: pivotalsingapore/spotlight-dashboard
	  env_file: docker_env
	  ports:
	    - "3030:80"
	  links:
	    - api
	```

3. Rename `docker_env.sample` to `docker_env` and edit your configuration as necessary:

	```yaml
	SECRET_KEY_BASE=<change_me!>
	WEB_HOST=/
	GOOGLE_API_CLIENT_ID=<change_me!>
	GOOGLE_API_CLIENT_SECRET=<change_me!>
	```

***Remember to add your own `SECRET_KEY_BASE`.***

### Starting the Spotlight Docker instance

1. Run the following command:

	```
	docker-compose run --rm api rake db:create db:migrate
	docker-compose up -d
	```

2. You can now access the dashboard via the container IP address (e.g. `http://192.168.99.100:3030`).

  *You can find out the IP address of the docker machine by running `docker-machine ls`.*

### Stopping Spotlight

To stop the Spotlight dashboard:

```
docker-compose stop
```

### Accessing Spotlight on your network

To make this dashboard available to your local area network (LAN), you should map one of your host OS's public ports to the Docker Machine's port 3030.

[Here's a nice write up](http://www.howtogeek.com/122641/how-to-forward-ports-to-a-virtual-machine-and-use-it-as-a-server/) on how to do so.

## Local Development Setup

To contribute code to this project, you will need to setup your local development environment to run Ruby and Rails. Here are the steps:

### A. Install Ruby

1. Install [Homebrew](http://brew.sh).

2. Install [rbenv](https://github.com/rbenv/rbenv):

	```
brew update
brew install rbenv ruby-build
```

3. Add `rbenv` support to your local profile:

	```
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
```

	If you are using `zsh`:

	```
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
```

3. Install the current Ruby version:

	```
rbenv install -l
rbenv install 2.3.0
```

4. Use it globally:

	```
rbenv global 2.3.0
```

### B. Install PostgreSQL database server

1. You will need [PostgreSQL](http://www.postgresql.org) installed and started.

	> If you are unfamiliar with PostgreSQL, we suggest that you download and install [Postgres Mac App](http://postgresapp.com). You may need to edit `config/database.yml` to [connect via TCP socket](http://postgresapp.com/documentation/configuration-ruby.html).

### C. Install Rails & other Gems

1. Install [Bundler](http://bundler.io/), the Ruby dependency management software:

	```
gem install bundler
```

2. Install the rest of the Ruby Gems needed for the app (including Ruby on Rails):

	```
bundle install
```

### D. Prepare the Database

1. Create the database:

	```
bundle exec rake db:create
```

2. Create the database tables:

	```
bundle exec rake db:migrate
```

3. Prepare sample data:

	```
bundle exec rake db:seed
```

### E. Start the development web server

1. Prepare the environment file (one time exercise):

  ```
cp env.sample .env
```

2. You can start the local development web server with the following command:

	```
foreman start
```

3. You can now visit the local development site at [http://localhost:3000](http://localhost:3000).

4. To stop the dev server, just press `ctrl` + `c` on your keyboard to stop the foreman process.


## Tests

We use the [RSpec](http://rspec.info) testing framework for this app.

To run the tests locally, use this command:

```
bundle exec rspec spec

```

To run the Javascript tests, use this command:

```
bundle exec rake spec:javascript
```

or open your browser to [http://localhost:3000/specs](http://localhost:3000/specs).


## Rebuilding the Docker container

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

4. Tag the image (assuming `ba3dcc9b42b1` is the latest image ID)

	```
docker tag ba3dcc9b42b1 pivotalsingapore/spotlight-rails:latest
```

5. Push to Docker Hub

	```
docker push pivotalsingapore/spotlight-rails
```

## Running in Concourse

```bash
fly -t aws login -c http://ci
fly -t aws set-pipeline -p spotlight-tests -c spotlight.yml -l credentials.yml
```

## Contributors

- [Carlos Gavino](https://github.com/cgavino)
- [Divya Bhargov](https://github.com/divyabhargov)
- Erika Buenaventura
- [Gabe Hollombe](https://github.com/gabehollombe)
- [Liza Ng](https://github.com/lizanys)
- [Michael Cheng](https://github.com/miccheng)
- [Rahul Rajeev](https://github.com/rhlrjv)
- [Swayam Narain](https://github.com/swayam18)
- [Yifeng Hou](https://github.com/mapleinspring)

## License

**The MIT License (MIT)**
Copyright (c) 2016 Pivotal Labs Singapore

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
