ailoads-demo
====================

Overview
------------
ailoads ([[https://github.com/loads/ailoads]]) is an auxiliarly tool for authoring loadtests to be used by the loads-broker tool (https://github.com/loads/loads-broker).

Purpose
-------------
The purpose of this project is to provide a loadtest 'skeleton' (or demo) that you can employ to write your own loadtests.

Summary
-------------
ailoads allows you to do the following tasks:

1. Create a docker image to 'house' your python loadtests 
2. Generate a configuration (json) file to be used by the loads-broker tool which defines the type of scale you want your loadtests to run in (i.e. number of attack nodes, what AWS region, size of attack nodes, length of tests, etc.)

File Contents
--------------
An ailoads repo should contain the following files:

1. loadtest.py
 * define your python loadtests in this file
2. loadtest.env
 * define any environment variables here
3. Dockerfile
 * define your docker container (to house your loadtests) here
4. \<project name\>.tpl
 * define your loads-broker config file in a tpl (template) format
5. Makefile
 * use this to generate by products required by the loads-broker tool (i.e. docker image, json config file)


Requirements
--------------

- Python 3.4

Execution
--------------


## How to run the loadtest?

### Example

    $ make setup_random test


### How to build the docker image?

    make docker-build


### How to run the docker image?

    make docker-run


### How to clean the repository?

    make clean

