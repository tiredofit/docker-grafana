# github.com/tiredofit/docker-grafana

[![GitHub release](https://img.shields.io/github/v/tag/tiredofit/docker-grafana?style=flat-square)](https://github.com/tiredofit/docker-grafana/releases/latest)
[![Build Status](https://img.shields.io/github/actions/workflow/status/tiredofit/docker-grafana/main.yml?branch=main&style=flat-square)](https://github.com/tiredofit/docker-grafana/actions)
[![Docker Stars](https://img.shields.io/docker/stars/tiredofit/grafana.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/grafana/)
[![Docker Pulls](https://img.shields.io/docker/pulls/tiredofit/grafana.svg?style=flat-square&logo=docker)](https://hub.docker.com/r/tiredofit/grafana/)
[![Become a sponsor](https://img.shields.io/badge/sponsor-tiredofit-181717.svg?logo=github&style=flat-square)](https://github.com/sponsors/tiredofit)
[![Paypal Donate](https://img.shields.io/badge/donate-paypal-00457c.svg?logo=paypal&style=flat-square)](https://www.paypal.me/tiredofit)

## About

This will allow you to build a Docker image for Grafana.

## Maintainer

- [Dave Conroy](http://github/tiredofit/)

## Table of Contents

- [github.com/tiredofit/docker-grafana](#githubcomtiredofitdocker-grafana)
  - [About](#about)
  - [Maintainer](#maintainer)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites and Assumptions](#prerequisites-and-assumptions)
  - [Installation](#installation)
    - [Build from Source](#build-from-source)
    - [Prebuilt Images](#prebuilt-images)
      - [Multi Architecture](#multi-architecture)
  - [Configuration](#configuration)
    - [Quick Start](#quick-start)
    - [Persistent Storage](#persistent-storage)
    - [Environment Variables](#environment-variables)
      - [Base Images used](#base-images-used)
  - [Maintenance](#maintenance)
    - [Shell Access](#shell-access)
  - [Support](#support)
    - [Usage](#usage)
    - [Bugfixes](#bugfixes)
    - [Feature Requests](#feature-requests)
    - [Updates](#updates)
  - [License](#license)
  - [References](#references)

## Prerequisites and Assumptions

## Installation
### Build from Source
Clone this repository and build the image with `docker build -t (imagename) .`

### Prebuilt Images
Builds of the image are available on [Docker Hub](https://hub.docker.com/r/tiredofit/grafana)

```bash
docker pull docker.io/tiredofit/grafana:(imagetag)
```
Builds of the image are also available on the [Github Container Registry](https://github.com/tiredofit/docker-grafana/pkgs/container/docker-grafana) 
 
```
docker pull ghcr.io/tiredofit/docker-grafana:(imagetag)
``` 

The following image tags are available along with their tagged release based on what's written in the [Changelog](CHANGELOG.md):

| Container OS | Tag       |
| ------------ | --------- |
| Alpine       | `:latest` |

#### Multi Architecture
Images are built primarily for `amd64` architecture, and may also include builds for `arm/v7`, `arm64` and others. These variants are all unsupported. Consider [sponsoring](https://github.com/sponsors/tiredofit) my work so that I can work with various hardware. To see if this image supports multiple architecures, type `docker manifest (image):(tag)`

## Configuration

### Quick Start

* The quickest way to get started is using [docker-compose](https://docs.docker.com/compose/). See the examples folder for a working [docker-compose.yml](examples/docker-compose.yml) that can be modified for development or production use.

* Set various [environment variables](#environment-variables) to understand the capabilities of this image.

### Persistent Storage
| File                   | Description                                                              |
| ---------------------- | ------------------------------------------------------------------------ |
| `/var/run/docker.sock` | You must have access to the docker socket in order to utilize this image |

* * *
### Environment Variables

| Parameter                            | Description                                | Default             |
| ------------------------------------ | ------------------------------------------ | ------------------- |
| `DB_TYPE`                            | DB engine type                             | `sqlite`            |
| `DB_HOST`                            | Database host                              | `localhost`         |
| `DB_PORT`                            | Database port                              | `3306`              |
| `DB_NAME`                            | Database name                              | `grafana`           |
| `DB_USER`                            | Database user                              | `grafana`           |
| `DB_PASS`                            | Database passwor                           | `password`          |
| `AUTO_ASSIGN_ORG_ROLE`               | Role for auto-created user                 | `Viewer`            |
| `OAUTH_ALLOW_INSECURE_EMAIL`         | If you use Generic OAuth with an identity<br> provider that does not support <br>a unique ID field please set it `TRUE` | `FALSE` |

#### Base Images used

This image relies on an [Alpine Linux](https://hub.docker.com/r/tiredofit/alpine) base image that relies on an [init system](https://github.com/just-containers/s6-overlay) for added capabilities. Outgoing SMTP capabilities are handlded via `msmtp`. Individual container performance monitoring is performed by [zabbix-agent](https://zabbix.org). Additional tools include: `bash`,`curl`,`less`,`logrotate`, `nano`.

Be sure to view the following repositories to understand all the customizable options:

| Image                                                  | Description                            |
| ------------------------------------------------------ | -------------------------------------- |
| [OS Base](https://github.com/tiredofit/docker-alpine/) | Customized Image based on Alpine Linux |


| Parameter           | Description                                                                             | Default                      |
| ------------------- | --------------------------------------------------------------------------------------- | ---------------------------- |

## Maintenance
### Shell Access

For debugging and maintenance purposes you may want access the containers shell.

```bash
docker exec -it (whatever your container name is e.g. grafana) bash
```

## Support

These images were built to serve a specific need in a production environment and gradually have had more functionality added based on requests from the community.
### Usage
- The [Discussions board](../../discussions) is a great place for working with the community on tips and tricks of using this image.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for personalized support
### Bugfixes
- Please, submit a [Bug Report](issues/new) if something isn't working as expected. I'll do my best to issue a fix in short order.

### Feature Requests
- Feel free to submit a feature request, however there is no guarantee that it will be added, or at what timeline.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) regarding development of features.

### Updates
- Best effort to track upstream changes, More priority if I am actively using the image in a production environment.
- Consider [sponsoring me](https://github.com/sponsors/tiredofit) for up to date releases.

## License
MIT. See [LICENSE](LICENSE) for more details.
## References

