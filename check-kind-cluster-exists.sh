#!/bin/bash

[ ! "$(sudo docker ps -a | grep potato)" ] && echo "no cluster"