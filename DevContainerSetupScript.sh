#!/bin/bash

export DEVPATHCONFIG=./.devconfig/ContainerName
function start-dev-container() {
  sudo docker start $(cat $DEVPATHCONFIG)
  sudo docker attach $(cat $DEVPATHCONFIG)
}

function create-dev-container() {
  sudo docker run -it --name $(cat $DEVPATHCONFIG) --mount type=bind,source=.,target=/workspace -w /workspace $1
}

function initialize-dev-container() {
  mkdir -p $(dirname $DEVPATHCONFIG)
  touch $DEVPATHCONFIG
  echo $1 >$DEVPATHCONFIG
}

export -f start-dev-container
export -f create-dev-container
export -f initialize-dev-container
