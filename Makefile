OS := $(shell uname)
HERE = $(shell pwd)
PYTHON = python3
#PYTHON = $(shell python3.4)
#PYTHON = '/usr/local/Cellar/python3/3.4.2_1/bin/python3'
VTENV_OPTS = --python $(PYTHON)

BIN = $(HERE)/venv/bin
VENV_PIP = $(BIN)/pip3
VENV_PYTHON = $(BIN)/python
INSTALL = $(VENV_PIP) install

LOOP_SERVER_URL = https://loop.stage.mozaws.net
#FXA_EXISTING_EMAIL = tryfmdstage@mailinator.com
FXA_EXISTING_EMAIL = ailoads-bitchin@mailinator.com

.PHONY: all check-os install-elcapitan install build
.PHONY: setup_random setup_existing configure 
.PHONY: docker-build docker-run docker-export
.PHONY: test test-heavy refresh clean

all: build setup_random configure 


# hack for OpenSSL problems on OS X El Captain: 
# https://github.com/phusion/passenger/issues/1630
check-os:
ifeq ($(OS),Darwin)
  ifneq ($(USER),root)
    $(info "clang now requires sudo, use: sudo make <target>.")
    $(info "Aborting!") && exit 1
  endif  
  BREW_PATH_OPENSSL=$(shell brew --prefix openssl)
endif

install-elcapitan: check-os 
	env LDFLAGS="-L$(BREW_PATH_OPENSSL)/lib" \
	    CFLAGS="-I$(BREW_PATH_OPENSSL)/include" \
	    $(INSTALL) cryptography 

$(VENV_PYTHON):
	virtualenv $(VTENV_OPTS) venv

install:
	$(INSTALL) -r requirements.txt

build: $(VENV_PYTHON) install-elcapitan install

clean-env: 
	@rm -f loadtest.env
	

setup_random: clean-env
	$(BIN)/fxa-client -c --browserid --prefix loop-server --audience $(LOOP_SERVER_URL) --out loadtest.env --duration 3600

setup_existing: clean-env
	$(BIN)/fxa-client --browserid --auth "$(FXA_EXISTING_EMAIL)" --account-server https://api.accounts.firefox.com/v1 --audience $(LOOP_SERVER_URL) --out loadtest.env --duration 3600

configure: build
	@bash loop.tpl


test: build loadtest.env
	bash -c "source loadtest.env && LOOP_SERVER_URL=$(LOOP_SERVER_URL):443 $(BIN)/ailoads -v -d 30"
	$(BIN)/flake8 loadtest.py

test-heavy: build loadtest.env
	bash -c "source loadtest.env && LOOP_SERVER_URL=$(LOOP_SERVER_URL):443 $(BIN)/ailoads -v -d 300 -u 10"


docker-build:
	docker build -t loop/loadtest .

docker-run: loadtest.env
	bash -c "source loadtest.env; docker run -e LOOP_DURATION=30 -e LOOP_NB_USERS=4 -e FXA_BROWSERID_ASSERTION=\$${FXA_BROWSERID_ASSERTION} loop/loadtest"

docker-export:
	docker save "loop/loadtest:latest" | bzip2> loop-latest.tar.bz2


clean: refresh
	@rm -fr venv/ __pycache__/ loadtest.env

