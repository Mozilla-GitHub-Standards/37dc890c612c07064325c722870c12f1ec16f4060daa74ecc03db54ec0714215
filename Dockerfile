# Mozilla SyncStorage Load-Tester
FROM stackbrew/debian:testing

MAINTAINER Karl Thieseen 

RUN \
    apt-get update; \
    apt-get install -y python-pip python-venv git build-essential make; \
    apt-get install -y python-dev libssl-dev libffi-dev; \
    git clone https://github.com/mozilla-services/ailoads-syncstorage /home/syncstorage; \
    cd /home/syncstorage; \
    pip3 install virtualenv; \
    make build -e PYTHON=python2.7; \
	apt-get remove -y -qq git build-essential make python-pip python-venv libssl-dev libffi-dev; \
    apt-get autoremove -y -qq; \
    apt-get clean -y

WORKDIR /home/syncstorage

# run the test
CMD venv/bin/ailoads -v -d $SYNCSTORAGE_DURATION -u $SYNCSTORAGE_NB_USERS
