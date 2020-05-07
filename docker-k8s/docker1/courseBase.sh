#!/bin/bash

docker rmi -f $(docker images -aq)
