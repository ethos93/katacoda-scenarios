#!/bin/bash

docker rmi -f $(docker images -aq)
docker volume prune -f
