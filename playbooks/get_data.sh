#!/bin/bash

if [ ! -d /opt/druid/data ]; then
    mkdir /opt/druid/data
fi

curl https://opendata.ecdc.europa.eu/covid19/casedistribution/json/ | jq -c '.records[]' | sed -e 's/\}\,/\}\n/g' > /opt/druid/data/`date +%Y%m%d`-covid19.json

