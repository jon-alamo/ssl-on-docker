#!/bin/sh

while true; do
  python /app/update_dns.py
  sleep $SLEEP_INTERVAL;
done
