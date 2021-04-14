# Docker Flighttracker

[![Build images](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build.yml/badge.svg)](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build.yml)
[![ft-dump1090 pulls](https://img.shields.io/docker/pulls/dennis14e/ft-dump1090?label=ft-dump1090%20pulls)](https://hub.docker.com/r/dennis14e/ft-dump1090)
[![ft-fr24feed pulls](https://img.shields.io/docker/pulls/dennis14e/ft-fr24feed?label=ft-fr24feed%20pulls)](https://hub.docker.com/r/dennis14e/ft-fr24feed)

**Supported architectures:**
- linux/amd64
- linux/arm/v6
- linux/arm/v7
- linux/arm64
- linux/386

**Tested on:**
- Raspberry Pi 4B
- Raspberry Pi 3B
- Raspberry Pi Zero W (`dump1090` runs well, `fr24feed` is not particularly stable)

**Tested adapters:**
- 0bda:2838 Realtek Semiconductor Corp. RTL2838 DVB-T


## Environment variables

| Image    | Environment variable | Default        | Description               |
|----------|----------------------|----------------|---------------------------|
| dump1090 | GMAP_STYLE           | old            | Map style old/new         |
| dump1090 | GMAP_CENTER_LAT      | 45.0           | Map center latitude       |
| dump1090 | GMAP_CENTER_LNG      | 9.0            | Map center longitude      |
| fr24feed | SHARING_KEY          |                | Flightradar24 sharing key |
| fr24feed | DUMP1090_HOST        | dump1090:30002 | dump1090 Host:Port        |


## Run with docker-compose

### Usage

1. Download `docker-compose.yml`
2. Set ports and environment variables
3. ???
4. Profit!

### Commands

| Description      | Command                  |
|------------------|--------------------------|
| Start containers | `docker-compose up -d`   |
| Stop containers  | `docker-compose down`    |
| Pull images      | `docker-compose pull`    |
| See logs         | `docker-compose logs -f` |


## Run dump1090

```
docker run \
  -it --rm \
  -p 8080:8080 \
  --device=/dev/bus/usb:/dev/bus/usb \
  -e GMAP_STYLE=new \
  -e GMAP_CENTER_LAT=45.0 \
  -e GMAP_CENTER_LNG=9.0 \
  dennis14e/ft-dump1090:latest
```


## Run fr24feed

```
docker run \
  -it --rm \
  -p 8754:8754 \
  -e SHARING_KEY=REPLACE \
  -e DUMP1090_HOST=dump1090:30002 \
  dennis14e/ft-fr24feed:latest
```
