#!/bin/bash

if [ ! "$(sudo docker ps -a | grep potato)" ]; then
    echo "no cluster"
else
    echo "has cluster"
fi