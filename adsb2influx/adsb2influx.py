#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Imports
import signal
import argparse
import logging
import socket
import re
import time

from influxdb_client import InfluxDBClient, Point
from influxdb_client.client.write_api import SYNCHRONOUS
from influxdb_client.rest import ApiException


# Logging
logging.basicConfig(
    level = logging.INFO,
    format = '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
log = logging.getLogger('adsb2influx')


# Killer
class GracefulKiller(object):
    kill_now = False

    def __init__(self):
        signal.signal(signal.SIGINT, self.handler)
        signal.signal(signal.SIGTERM, self.handler)

    def handler(self, sig, frame):
        self.kill_now = True


# AdsbProcessor
class AdsbProcessor(object):
    MSG_REGEX = r'^MSG,' \
        r'(?P<transmission>\d),' \
        r'(?P<session>\d*),' \
        r'(?P<aircraft>\d*),' \
        r'(?P<hexident>[0-9A-F]+),' \
        r'(?P<flight>\d*),' \
        r'(?P<gen_date>[0-9/]*),' \
        r'(?P<gen_time>[0-9:\.]*),' \
        r'(?P<log_date>[0-9/]*),' \
        r'(?P<log_time>[0-9:\.]*),' \
        r'(?P<callsign>[\w\s]*),' \
        r'(?P<altitude>\d*),' \
        r'(?P<speed>\d*),' \
        r'(?P<track>[\d\-]*),' \
        r'(?P<latitude>[\d\-\.]*),' \
        r'(?P<longitude>[\d\-\.]*),' \
        r'(?P<verticalrate>[\d\-]*),' \
        r'(?P<squawk>\d*),' \
        r'(?P<alert>[\d\-]*),' \
        r'(?P<emergency>[\d\-]*),' \
        r'(?P<spi>[\d\-]*),' \
        r'(?P<onground>[\d\-]*)$'

    MSG_NORMAL = {
        'transmission': (lambda v: int(v)),
        'session': (lambda v: int(v)),
        'aircraft': (lambda v: int(v)),
        'flight': (lambda v: int(v)),
        'callsign': (lambda v: v.strip()),
        'altitude': (lambda v: int(v)),
        'speed': (lambda v: int(v)),
        'track': (lambda v: int(v)),
        'latitude': (lambda v: float(v)),
        'longitude': (lambda v: float(v)),
        'verticalrate': (lambda v: int(v)),
        'alert': (lambda v: True if v == '-1' else False),
        'emergency': (lambda v: True if v == '-1' else False),
        'spi': (lambda v: True if v == '-1' else False),
        'onground': (lambda v: True if v == '-1' else False),
    }

    def __init__(self):
        self.re_msg = re.compile(self.MSG_REGEX)
        self.aircrafts = {}
        self.aircrafts_age = {}

    def __getitem__(self, key):
        return self.aircrafts[key]

    def __setitem__(self, key, value):
        self.aircrafts[key] = value

    def __delitem__(self, key):
        del self.aircrafts[key]

    def __contains__(self, key):
        return key in self.aircrafts

    def __len__(self):
        return len(self.aircrafts)

    def __repr__(self):
        return repr(self.aircrafts)

    def __cmp__(self, dict_):
        return self.__cmp__(self.aircrafts, dict_)

    def __iter__(self):
        return iter(self.aircrafts)

    def __unicode__(self):
        return unicode(repr(self.aircrafts))

    def __normalize_msg(self, msg):
        for field, fnc in self.MSG_NORMAL.items():
            if field in msg:
                msg[field] = fnc(msg[field])

        return msg

    def keys(self):
        return self.aircrafts.keys()

    def values(self):
        return self.aircrafts.values()

    def items(self):
        return self.aircrafts.items()

    def pop(self, *args):
        return self.aircrafts.pop(*args)

    def clear(self, age):
        for hexident in list(self.aircrafts_age.keys()):
            if hexident in self.aircrafts:
                del self.aircrafts_age[hexident]
                continue

            if (time.time() - self.aircrafts_age[hexident]) > age:
                log.info('Hexident {} is too old, deleting'.format(hexident))
                del self.aircrafts_age[hexident]
                del self.aircrafts[hexident]

        for hexident in self.aircrafts.keys():
            self.aircrafts[hexident]['count'] = 0

    def age(self, hexident):
        return (time.time() - self.aircrafts_age.get(hexident, 0))

    def msg(self, data):
        log.debug(data)

        data = data.strip()

        matches = self.re_msg.match(data)
        if not matches:
            log.error('Wrong format for MSG \'{}\', skipping...'.format(data))
            return

        msg = { k: v for k, v in matches.groupdict().items() if v }
        msg = self.__normalize_msg(msg)

        self.aircrafts_age[msg['hexident']] = time.time()

        if msg['hexident'] not in self.aircrafts:
            self.aircrafts[msg['hexident']] = msg
            self.aircrafts[msg['hexident']]['count'] = 1
        else:
            self.aircrafts[msg['hexident']].update(msg)
            self.aircrafts[msg['hexident']]['count'] += 1


# dump1090
class Dump1090(object):
    def __init__(self, host, port):
        self.host = host
        self.port = port
        self.socket = None
        self.data = ''

    def connect(self):
        log.info('Connecting to dump1090 on {}:{}'.format(self.host, self.port))
        self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        connected = False

        while not connected:
            try:
                self.socket.connect((self.host, self.port))
                connected = True
                log.info('Connected OK, receiving data')
            except Exception as e:
                connected = False
                log.warning('Could not connect, retrying ({})'.format(e))

        self.socket.setblocking(False)
        self.socket.settimeout(1)

    def disconnect(self):
        self.socket.close()
        log.info('Disconnected from dump1090')

    def receive(self):
        ret = None

        try:
            self.data += self.socket.recv(1024).decode('UTF-8')
            self.socket.send(bytes("\n", 'UTF-8'))

            newline = self.data.find('\n')
            if newline >= 0:
                ret = self.data[:newline]
                self.data = self.data[newline + 1:]
        except socket.timeout:
            pass
        except Exception as e:
            log.error('Error receiving data from dump1090: \'{}\''.format(e))

        return ret


# InfluxDB
class InfluxDB(object):
    def __init__(self, url, token, org, bucket):
        self.org = org
        self.bucket = bucket

        self.client = InfluxDBClient(
            url = url,
            token = token,
            org = org
        )

        self.writeapi = self.client.write_api(
            write_options = SYNCHRONOUS
        )

    def write(self, data):
        log.debug('Write data to InfluxDB: {}'.format(data))

        try:
            self.writeapi.write(self.bucket, self.org, data)
            log.info('Written {} aircraft to InfluxDB'.format(len(data)))
        except ApiException as e:
            log.error('Writing data to InfluxDB failed, status code: {} {}'.format(e.status, e.reason))
            return False

        return True


# Main
def main():
    parser = argparse.ArgumentParser(
        description = 'Write ADSB data from dump1090 to InfluxDB 2.0'
    )

    parser.add_argument(
        '-dh', '--dump1090-host',
        dest = 'dump1090_host',
        default = 'localhost',
        help = 'dump1090 host/ip (default: localhost)'
    )
    parser.add_argument(
        '-dp', '--dump1090-port',
        dest = 'dump1090_port',
        type = int,
        default = 30003,
        help = 'dump1090 port (default: 30003)'
    )
    parser.add_argument(
        '-iu', '--influxdb-url',
        dest = 'influxdb_url',
        required = True,
        help = 'InfluxDB url (e.g. http://url-to-influxdb:8086/)'
    )
    parser.add_argument(
        '-it', '--influxdb-token',
        dest = 'influxdb_token',
        required = True,
        help = 'InfluxDB API token'
    )
    parser.add_argument(
        '-io', '--influxdb-org',
        dest = 'influxdb_org',
        required = True,
        help = 'InfluxDB organisation'
    )
    parser.add_argument(
        '-ib', '--influxdb-bucket',
        dest = 'influxdb_bucket',
        default = 'adsb',
        help = 'InfluxDB bucket (default: adsb)'
    )
    parser.add_argument(
        '-im', '--influxdb-measurement',
        dest = 'influxdb_measurement',
        default = 'messages',
        help = 'InfluxDB measurement (default: messages)'
    )
    parser.add_argument(
        '-si', '--send-interval',
        dest = 'send_interval',
        type = int,
        default = 60,
        help = 'send interval in seconds (default: 60)'
    )
    parser.add_argument(
        '-d', '--debug',
        dest = 'debug',
        action = 'store_true',
        help = 'set logging to debug level'
    )

    args = parser.parse_args()


    # Logging
    if args.debug == True:
        log.setLevel(logging.DEBUG)

    log.debug('Arguments: {}'.format(args))


    # Killer
    killer = GracefulKiller()

    # AdsbProcessor
    ap = AdsbProcessor()

    # dump1090
    dump1090 = Dump1090(args.dump1090_host, args.dump1090_port)
    dump1090.connect()

    # InfluxDB
    influxdb = InfluxDB(
        url = args.influxdb_url,
        token = args.influxdb_token,
        org = args.influxdb_org,
        bucket = args.influxdb_bucket
    )


    measurement = args.influxdb_measurement
    send_interval = args.send_interval
    last_print = time.time()


    # This is where the magic happens
    while not killer.kill_now:
        if (time.time() - last_print) > send_interval:
            last_print = time.time()

            to_send = []

            for hexident, msg in ap.items():
                if not all(k in msg for k in ['callsign', 'squawk']):
                    log.info('Missing callsign or squawk for {}'.format(hexident))
                    continue

                if ap.age(hexident) > send_interval:
                    log.info('Aircraft {} was not seen too long. Not sending'.format(hexident))
                    continue

                to_send.append({
                    'measurement': measurement,
                    'tags': {
                        'hexident': hexident,
                        'callsign': msg['callsign'],
                        'squawk': msg['squawk'],
                    },
                    'fields': {
                        'generated': time.time(),
                        'altitude': msg.get('altitude'),
                        'speed': msg.get('speed'),
                        'track': msg.get('track'),
                        'latitude': msg.get('latitude'),
                        'longitude': msg.get('longitude'),
                        'verticalrate': msg.get('verticalrate'),
                        'alert': msg.get('alert'),
                        'emergency': msg.get('emergency'),
                        'spi': msg.get('spi'),
                        'onground': msg.get('onground'),
                        'count': msg.get('count', 0),
                    }
                })


            ap.clear(send_interval * 3)
            if len(to_send) > 0:
                influxdb.write(to_send)
            else:
                log.info('No aircrafts to be saved in InfluxDB')


        msg = dump1090.receive()
        if msg is not None:
            ap.msg(msg)


    # Exit
    dump1090.disconnect()


if __name__ == "__main__":
    main()
