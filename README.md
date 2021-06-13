# Docker Flighttracker

[![Build stable images](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-stable.yml/badge.svg)](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-stable.yml)
[![Build develop images](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-develop.yml/badge.svg)](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-develop.yml)

[![dump1090 pulls](https://img.shields.io/docker/pulls/flighttracker/dump1090?label=dump1090%20pulls)](https://hub.docker.com/r/flighttracker/dump1090)
[![readsb pulls](https://img.shields.io/docker/pulls/flighttracker/readsb?label=readsb%20pulls)](https://hub.docker.com/r/flighttracker/readsb)
[![fr24feed pulls](https://img.shields.io/docker/pulls/flighttracker/fr24feed?label=fr24feed%20pulls)](https://hub.docker.com/r/flighttracker/fr24feed)
[![adsb2influx pulls](https://img.shields.io/docker/pulls/flighttracker/adsb2influx?label=adsb2influx%20pulls)](https://hub.docker.com/r/flighttracker/adsb2influx)
[![web-light pulls](https://img.shields.io/docker/pulls/flighttracker/web-light?label=web-light%20pulls)](https://hub.docker.com/r/flighttracker/web-light)


## Supported architectures
- linux/amd64
- linux/arm/v6
- linux/arm/v7
- linux/arm64
- linux/386


## Tested on
- Raspberry Pi 4B
- Raspberry Pi 3B
- Raspberry Pi Zero W (`dump1090` runs well, `fr24feed` is not particularly stable)


## Tested adapters
- *Should work with every RTL-SDR dongle*
- `0bda:2838` Realtek Semiconductor Corp. RTL2838 DVB-T


## Used software
- [dump1090](https://github.com/antirez/dump1090)
- [readsb](https://github.com/wiedehopf/readsb)
- [fr24feed](https://www.flightradar24.com/share-your-data)
- [adsb2influx](https://github.com/slintak/adsb2influx) (own fork, only for InfluxDB 2.0)
- [Alpine Linux](https://www.alpinelinux.org/)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Font Awesome](https://fontawesome.com/)
- [Leaflet](https://github.com/Leaflet/Leaflet)


## Image "dump1090"

### Environment variables

| Environment variable | Default        | Description          |
|----------------------|----------------|----------------------|
| TITLE                | dump1090       | Page title           |
| GMAP_STYLE           | old            | Map style old/new    |
| GMAP_CENTER_LAT      | 45.0           | Map center latitude  |
| GMAP_CENTER_LNG      | 9.0            | Map center longitude |

### docker run

```
docker run \
  -it --rm \
  -p 8080:8080 \
  --device=/dev/bus/usb:/dev/bus/usb \
  -e GMAP_STYLE=new \
  -e GMAP_CENTER_LAT=45.0 \
  -e GMAP_CENTER_LNG=9.0 \
  flighttracker/dump1090:latest
```


## Image "readsb"

### Environment variables

| Environment variable | Default                                                                                         | Description      |
|----------------------|-------------------------------------------------------------------------------------------------|------------------|
| RECEIVER_OPTIONS     | see [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile) | Receiver options |
| DECODER_OPTIONS      | see [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile) | Decoder options  |
| NET_OPTIONS          | see [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile) | Network options  |
| JSON_OPTIONS         | see [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile) | JSON options     |

### docker run

```
docker run \
  -it --rm \
  --device=/dev/bus/usb:/dev/bus/usb \
  flighttracker/readsb:latest
```


## Image "fr24feed"

fr24feed is compatible with dump1090 and readsb.

### Environment variables

| Environment variable | Default        | Description               |
|----------------------|----------------|---------------------------|
| SHARING_KEY          |                | Flightradar24 sharing key |
| DUMP1090_HOST        | dump1090:30002 | dump1090 Host:Port        |
| RECEIVER             | avr-tcp        | Receiver type             |
| BS                   | no             | BS                        |
| RAW                  | no             | RAW                       |
| LOGMODE              | 0              | Logging mode              |
| WINDOWMODE           | 0              | Window mode               |
| MPX                  | no             | MPX                       |
| MLAT                 | yes            | MLAT                      |
| MLAT_WITHOUT_GPS     | yes            | MLAT without GPS          |

### docker run

```
docker run \
  -it --rm \
  -p 8754:8754 \
  -e SHARING_KEY=REPLACE \
  -e DUMP1090_HOST=dump1090:30002 \
  flighttracker/fr24feed:latest
```


## Image "web-light"

web-light is only compatible with readsb.

### Environment variables

| Environment variable | Default                 | Description             |
|----------------------|-------------------------|-------------------------|
| READSB_HOST          | readsb                  | readsb Host             |
| READSB_PORT          | 8042                    | readsb API Port         |
| PAGE_TITLE           | Flighttracker Web Light | Page title              |
| REFRESH_RATE         | 250                     | Data refresh rate in ms |
| CENTER_LAT           | 45.0                    | Map center latitude     |
| CENTER_LNG           | 9.0                     | Map center longitude    |
| CENTER_RANGE         | 500                     | Map range in nm         |

### docker run

```
docker run \
  -it --rm \
  -p 80:80 \
  -e SHARING_KEY=REPLACE \
  -e DUMP1090_HOST=dump1090:30002 \
  flighttracker/web-light:latest
```


## Image "adsb2influx"

adsb2influx is compatible with dump1090 and readsb.

### Environment variables

| Environment variable | Default        | Description              |
|----------------------|----------------|--------------------------|
| DUMP1090_HOST        | dump1090       | dump1090 Host            |
| DUMP1090_PORT        | 30003          | dump1090 Port            |
| INFLUX_URL           |                | InfluxDB URL             |
| INFLUX_TOKEN         |                | InfluxDB API token       |
| INFLUX_ORG           |                | InfluxDB organisation    |
| INFLUX_BUCKET        | adsb           | InfluxDB bucket          |
| INFLUX_MEASUREMENT   | messages       | InfluxDB measurement     |
| SEND_INTERVAL        | 60             | Data send interval (sec) |

### docker run
```
docker run \
  -it --rm \
  -e DUMP1090_HOST=dump1090 \
  -e DUMP1090_PORT=30003 \
  -e INFLUX_URL= \
  -e INFLUX_TOKEN= \
  -e INFLUX_ORG= \
  -e INFLUX_BUCKET=adsb \
  -e SEND_INTERVAL=60 \
  flighttracker/adsb2influx:latest
```


## Run with docker-compose

### Usage

1. Download `docker-compose.dump1090.yml` or `docker-compose.readsb.yml`
2. Rename the downloaded file to `docker-compose.yml`
3. Edit `docker-compose.yml` and set services, ports and environment variables
4. ???
5. Profit!

### Commands

| Description      | Command                  |
|------------------|--------------------------|
| Start containers | `docker-compose up -d`   |
| Stop containers  | `docker-compose down`    |
| Pull images      | `docker-compose pull`    |
| See logs         | `docker-compose logs -f` |
