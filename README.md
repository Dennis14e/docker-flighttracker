# Docker Flighttracker

[![Build release images](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-release.yml/badge.svg)](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-release.yml)
[![Build develop images](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-develop.yml/badge.svg)](https://github.com/Dennis14e/docker-flighttracker/actions/workflows/build-develop.yml)


## Attention!
This project is slowly being replaced by my new project [flighttrackr](https://github.com/flighttrackr).
Many images can already be found there.


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

### Encoders and more
- [readsb](https://github.com/wiedehopf/readsb)
- [dump1090](https://github.com/antirez/dump1090)
- [dump978](https://github.com/flightaware/dump978)

### Feeders
- [fr24feed](https://www.flightradar24.com/share-your-data)
- [planefinder](https://planefinder.net/coverage)
- [adsb2influx](https://github.com/slintak/adsb2influx) (own fork, only for InfluxDB 2.0)
- [mlat-client](https://github.com/wiedehopf/mlat-client)

### Utilities
- [uat2esnt](https://github.com/adsbxchange/uat2esnt)

### Additional software
- [Alpine Linux](https://www.alpinelinux.org/)
- [OpenStreetMap](https://www.openstreetmap.org/)
- [Font Awesome](https://fontawesome.com/)
- [Leaflet](https://github.com/Leaflet/Leaflet)


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


## Image "readsb"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/readsb) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/readsb/latest)](https://hub.docker.com/r/flighttracker/readsb)

### Environment variables

See `ENV`-lines in [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/readsb/Dockerfile).

### docker run

```
docker run \
  -it --rm \
  --device=/dev/bus/usb:/dev/bus/usb \
  flighttracker/readsb:latest
```


## Image "readsb-web"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/readsb-web) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/readsb-web/latest)](https://hub.docker.com/r/flighttracker/readsb-web)

readsb-web is only compatible with readsb.

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
  -e CENTER_LAT=REPLACE \
  -e CENTER_LNG=REPLACE \
  -e CENTER_RANGE=REPLACE \
  flighttracker/readsb-web:latest
```


## Image "dump1090"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/dump1090) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/dump1090/latest)](https://hub.docker.com/r/flighttracker/dump1090)

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


## Image "dump978"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/dump978) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/dump978/latest)](https://hub.docker.com/r/flighttracker/dump978)

### Warning

dump978 is currently not supported due to unexplained problems building Docker images.

### Environment variables

See `ENV`-lines in [Dockerfile](https://github.com/Dennis14e/docker-flighttracker/blob/main/dump978/Dockerfile).

### docker run

```
docker run \
  -it --rm \
  -p 30002:30002 \
  --device=/dev/bus/usb:/dev/bus/usb \
  flighttracker/dump978:latest
```


## Image "uat2esnt"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/uat2esnt) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/uat2esnt/latest)](https://hub.docker.com/r/flighttracker/uat2esnt)

uat2esnt is only compatible with dump978.

### Environment variables

| Environment variable | Default | Description  |
|----------------------|---------|--------------|
| DUMP978_HOST         | dump978 | dump978 host |
| DUMP978_PORT         | 30002   | dump978 port |
| OUTPUT_PORT          | 30002   | Output port  |

### docker run

```
docker run \
  -it --rm \
  -p 30002:30002 \
  flighttracker/uat2esnt:latest
```


## Image "mlat-client"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/mlat-client) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/mlat-client/latest)](https://hub.docker.com/r/flighttracker/mlat-client)

### Environment variables

| Environment variable | Default               | Description                                                                                                           |
|----------------------|-----------------------|-----------------------------------------------------------------------------------------------------------------------|
| INPUT_TYPE           | auto                  | Input type: `auto`, `dump1090`, `beast`, `radarcape_12mhz`, `radarcape_gps`, `radarcape`, `sbs`, `avrmlat`            |
| INPUT_CONNECT_HOST   |                       | Input host to connect to for Mode S traffic                                                                           |
| INPUT_CONNECT_PORT   | 30002                 | Input port to connect to for Mode S traffic                                                                           |
| RESULTS              |                       | `<protocol>,connect,<host:port>` or `<protocol>,listen,<port>`<br>Protocol: `basestation`, `ext_basestation`, `beast` |
| NO_ANON_RESULTS      | no                    | No results for anonymized aircraft: `yes`, `no`                                                                       |
| NO_MODEAC_RESULTS    | no                    | No results for Mode A/C tracks: `yes`, `no`                                                                           |
| LAT                  |                       | Latitude of receiver                                                                                                  |
| LON                  |                       | Longitude of receiver                                                                                                 |
| ALT                  |                       | Altitude of receiver (in `m` or `ft`)                                                                                 |
| PRIVACY              | no                    | Sets the privacy flag for this receiver: `yes`, `no`                                                                  |
| USER                 |                       | User information to give to the server                                                                                |
| SERVER_HOST          | feed.adsbexchange.com | Host of the multilateration server to connect to                                                                      |
| SERVER_PORT          | 31090                 | Port of the multilateration server to connect to                                                                      |
| NO_UDP               | no                    | Don't offer to use UDP transport for sync/mlat messages: `yes`, `no`                                                  |
| LOG_TIMESTAMPS       | no                    | Print timestamps in logging output: `yes`, `no`                                                                       |

### docker run
```
docker run \
  -it --rm \
  -e INPUT_CONNECT_HOST=readsb \
  -e INPUT_CONNECT_PORT=30002 \
  -e LAT= \
  -e LON= \
  -e ALT= \
  -e USER= \
  flighttracker/mlat-client:latest
```


## Image "fr24feed"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/fr24feed) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/fr24feed/latest)](https://hub.docker.com/r/flighttracker/fr24feed)

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


## Image "pfclient"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/pfclient) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/pfclient/latest)](https://hub.docker.com/r/flighttracker/pfclient)

pfclient is compatible with dump1090 and readsb.

### Environment variables

| Environment variable | Default  | Description             |
|----------------------|----------|-------------------------|
| SHARING_KEY          |          | Planefinder sharing key |
| DUMP1090_HOST        | dump1090 | dump1090 Host           |
| DUMP1090_PORT        | 30002    | dump1090 Port           |
| LAT                  |          | Latitude of receiver    |
| LON                  |          | Longitude of receiver   |

### docker run

```
docker run \
  -it --rm \
  -p 30053:30053 \
  -e SHARING_KEY=REPLACE \
  -e DUMP1090_HOST=dump1090 \
  -e DUMP1090_PORT=30002 \
  -e LAT=REPLACE \
  -e LON=REPLACE \
  flighttracker/pfclient:latest
```


## Image "adsb2influx"
[![Docker Pulls](https://img.shields.io/docker/pulls/flighttracker/adsb2influx) ![Docker Image Size (tag)](https://img.shields.io/docker/image-size/flighttracker/adsb2influx/latest)](https://hub.docker.com/r/flighttracker/adsb2influx)

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
