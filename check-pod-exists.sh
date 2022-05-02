#!/bin/bash

if [ ! "$(sudo kubectl get pod -l 'a=b' -n podnamespace)" ]; then
  echo "no pod"
else
  echo "has pod"
fi