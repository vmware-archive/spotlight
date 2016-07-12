# Setting up Concourse CI

## Building Base Box

Before you can build a test box in ConcourseCI, you will need a base box to contain all your essential GEMs.

```bash
docker build -t pivotalsingapore/concourse-base-rails -f Dockerfile.rails-base .
```

Push to `pivotalsingapore` on Docker Hub

```bash
docker push pivotalsingapore/concourse-base-rails
```

## Building Test Box

```bash
docker build -t pivotalsingapore/spotlight-tests -f Dockerfile.tests .
```

Push that `pivotalsingapore` Docker Hub

```bash
docker push pivotalsingapore/concourse-tests
```

## Setting up Concourse CI with Fly CLI

Add the Concourse Pipeline using these commands. Remember to create a `credentials.yml` file.

```
---
docker-email: <dockerhub_email>
docker-username: <dockerhub_username>
docker-password: <dockerhub_password>
git-private-key: |
  -----BEGIN RSA PRIVATE KEY-----
	<private key of user who has access to GitHub project>
  -----END RSA PRIVATE KEY-----
```

Commands to run:

```bash
fly -t aws login -c http://ci
fly -t aws set-pipeline -p spotlight-tests -c spotlight.yml -l credentials.yml
```
