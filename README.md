# Covid-19 Druid example

This is an example of using [apache druid](https://druid.apache.org/) as database together with [apache superset](https://superset.incubator.apache.org/) to visualize data.

## Preparation

- Get an aws/azure/google instance with ubuntu 20 LTS
- Make sure that ports 8888 and 22 (ssh) are accessible from outside
- Make sure python is installed on host
- have ansible running on your system (use linux bash on Windows 10 machines)
- have Docker-ce installed on your machine

## Installation of druid on cloud instance

- change to `playbook`-folder
- copy `hosts.example` to hosts and edit to insert your cloud instance's dns name
- edit `user` in `install.yml` if neccessary (`ubuntu`-user is ok for aws)
- run command `ansible-playbook install.yml -i hosts --private-key <path to your ssh key>`
- log in to your cloud instance and execute `/opt/druid/scripts/get_data.sh`. This will copy Covid-19-Data to `/opt/druid/data`-folder
- start druid with command `sudo /opt/druid/apache-druid-0.19.0/bin/start-micro-quickstart`

## Load Data into druid

- open Druid-Console on `http://<cloud-host>:8888`
- sect `Load Data` -> `local disk`
- enter path `/opt/druid/data`
- select `Next: parse data`
- select `Next: parse time`
- select `Next: Transform`
- select `Next: Filter`
- select `Next: Configure schema`
- select `Next: Configure partition` and select `Segment Granularity` as `Day`
- Continue until you can publish the spec.
- Wait until datasource becomes available

## Start superset

- enter `docker-compose up -d` in main directory of this project
- log in to superset using `http://localhost:8088` using `admin/superset`as credentials
- Add datasource with `Database` as `pydruid` and `SQLAlchemy URI` as `druid://<cloud-instance-fqdn>:8888/druid/v2/sql`
- Add Table with `Table Name` as `data` and `Database` as `pydruid`
- Create new Dashboard and start filling it :-)
