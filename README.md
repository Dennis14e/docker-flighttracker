# Docker Flighttracker

[![Build stable images](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-stable.yml/badge.svg)](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-stable.yml)
[![Build develop images](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-develop.yml/badge.svg)](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-develop.yml)

[![dump1090 pulls](https://img.shields.io/docker/pulls/flighttracker/dump1090?label=dump1090%20pulls)](https://hub.docker.com/r/flighttracker/dump1090)
[![readsb pulls](https://img.shields.io/docker/pulls/flighttracker/readsb?label=readsb%20pulls)](https://hub.docker.com/r/flighttracker/readsb)
[![fr24feed pulls](https://img.shields.io/docker/pulls/flighttracker/fr24feed?label=fr24feed%20pulls)](https://hub.docker.com/r/flighttracker/fr24feed)
[![adsb2influx pulls](https://img.shields.io/docker/pulls/flighttracker/adsb2influx?label=adsb2influx%20pulls)](https://hub.docker.com/r/flighttracker/adsb2influx)

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

**Used software:**
- [dump1090](https://github.com/antirez/dump1090)
- [readsb](https://github.com/wiedehopf/readsb)
- [fr24feed](https://www.flightradar24.com/share-your-data)
- [adsb2influx](https://github.com/slintak/adsb2influx) (own fork, only for InfluxDB 2.0)
- [Alpine Linux](https://www.alpinelinux.org/)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Font Awesome](https://fontawesome.com/)
- [Leaflet](https://github.com/Leaflet/Leaflet)


## Environment variables

| Image       | Environment variable | Default        | Description               |
|-------------|----------------------|----------------|---------------------------|
| dump1090    | TITLE                | dump1090       | Page title                |
| dump1090    | GMAP_STYLE           | old            | Map style old/new         |
| dump1090    | GMAP_CENTER_LAT      | 45.0           | Map center latitude       |
| dump1090    | GMAP_CENTER_LNG      | 9.0            | Map center longitude      |
| readsb      | RECEIVER_OPTIONS     | see [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile) | Receiver options          |
| readsb      | DECODER_OPTIONS      | see [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile) | Decoder options           |
| readsb      | NET_OPTIONS          | see [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile) | Network options           |
| readsb      | JSON_OPTIONS         | see [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile) | JSON options              |
| fr24feed    | SHARING_KEY          |                | Flightradar24 sharing key |
| fr24feed    | DUMP1090_HOST        | dump1090:30002 | dump1090 Host:Port        |
| fr24feed    | RECEIVER             | avr-tcp        | Receiver type             |
| fr24feed    | BS                   | no             | BS                        |
| fr24feed    | RAW                  | no             | RAW                       |
| fr24feed    | LOGMODE              | 0              | Logging mode              |
| fr24feed    | WINDOWMODE           | 0              | Window mode               |
| fr24feed    | MPX                  | no             | MPX                       |
| fr24feed    | MLAT                 | yes            | MLAT                      |
| fr24feed    | MLAT_WITHOUT_GPS     | yes            | MLAT without GPS          |
| adsb2influx | DUMP1090_HOST        | dump1090       | dump1090 Host             |
| adsb2influx | DUMP1090_PORT        | 30003          | dump1090 Port             |
| adsb2influx | INFLUX_URL           |                | InfluxDB URL              |
| adsb2influx | INFLUX_TOKEN         |                | InfluxDB API token        |
| adsb2influx | INFLUX_ORG           |                | InfluxDB organisation     |
| adsb2influx | INFLUX_BUCKET        | adsb           | InfluxDB bucket           |
| adsb2influx | INFLUX_MEASUREMENT   | messages       | InfluxDB measurement      |
| adsb2influx | SEND_INTERVAL        | 60             | Data send interval (sec)  |


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


## Run dump1090

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


## Run readsb

```
docker run \
  -it --rm \
  --device=/dev/bus/usb:/dev/bus/usb \
  flighttracker/readsb:latest
```


## Run fr24feed

```
docker run \
  -it --rm \
  -p 8754:8754 \
  -e SHARING_KEY=REPLACE \
  -e DUMP1090_HOST=dump1090:30002 \
  flighttracker/fr24feed:latest
```


## Run adsb2influx

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
