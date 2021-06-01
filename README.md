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

**Used software:**
- [dump1090](https://github.com/antirez/dump1090)
- [fr24feed](https://www.flightradar24.com/share-your-data)
- [Alpine Linux](https://www.alpinelinux.org/)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Font Awesome](https://fontawesome.com/)
- [Leaflet](https://github.com/Leaflet/Leaflet)
- [adsb2influx](https://github.com/slintak/adsb2influx) (own fork, only for InfluxDB 2.0)


## Environment variables

| Image          | Environment variable | Default        | Description               |
|----------------|----------------------|----------------|---------------------------|
| ft-dump1090    | TITLE                | dump1090       | Page title                |
| ft-dump1090    | GMAP_STYLE           | old            | Map style old/new         |
| ft-dump1090    | GMAP_CENTER_LAT      | 45.0           | Map center latitude       |
| ft-dump1090    | GMAP_CENTER_LNG      | 9.0            | Map center longitude      |
| ft-fr24feed    | SHARING_KEY          |                | Flightradar24 sharing key |
| ft-fr24feed    | DUMP1090_HOST        | dump1090:30002 | dump1090 Host:Port        |
| ft-fr24feed    | RECEIVER             | avr-tcp        | Receiver type             |
| ft-fr24feed    | BS                   | no             | BS                        |
| ft-fr24feed    | RAW                  | no             | RAW                       |
| ft-fr24feed    | LOGMODE              | 0              | Logging mode              |
| ft-fr24feed    | WINDOWMODE           | 0              | Window mode               |
| ft-fr24feed    | MPX                  | no             | MPX                       |
| ft-fr24feed    | MLAT                 | yes            | MLAT                      |
| ft-fr24feed    | MLAT_WITHOUT_GPS     | yes            | MLAT without GPS          |
| ft-adsb2influx | DUMP1090_HOST        | dump1090       | dump1090 Host             |
| ft-adsb2influx | DUMP1090_PORT        | 30003          | dump1090 Port             |
| ft-adsb2influx | INFLUX_URL           |                | InfluxDB URL              |
| ft-adsb2influx | INFLUX_TOKEN         |                | InfluxDB API token        |
| ft-adsb2influx | INFLUX_ORG           |                | InfluxDB organisation     |
| ft-adsb2influx | INFLUX_BUCKET        | adsb           | InfluxDB bucket           |
| ft-adsb2influx | INFLUX_MEASUREMENT   | messages       | InfluxDB measurement      |
| ft-adsb2influx | SEND_INTERVAL        | 60             | Data send interval (sec)  |


## Run with docker-compose

### Usage

1. Download `docker-compose.yml`
2. Set services, ports and environment variables
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
  dennis14e/ft-adsb2influx:latest
```
