#!/bin/bash

usage(){
    echo "This script will install some necessary programs for your server."
    echo
    echo "Usage:"
    echo "      ./configure-new-server.sh -d -kl -kd"
    echo
    echo "Where:"
    echo "      -d (--docker): installs Docker"
    echo "      -kl (--kubectl): installs kubectl"
    echo "      -kd (--kind): installs kind"
    echo "      -h (--help): this page"
    echo
    echo "Created by @Guilospanck"
}

if [[ $# -eq 0 ]] ; then
  usage
  exit 0
fi

install_docker(){
    echo "----- Installing Docker..."
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
    apt-cache policy docker-ce
    sudo apt install docker-ce -y
    echo "----- Docker installed!"
}

install_kubectl(){
    echo "----- Installing kubectl..."
    sudo apt update
    sudo apt install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
    echo "----- kubectl installed!"
}

install_kind(){    
    echo "----- Installing kind..."
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin
    echo "----- kind installed!"
}

for i in "$@"; do
  case $i in
    -d|--docker)
      install_docker
      shift # past argument=value
      ;;
    -kl|--kubectl)
      install_kubectl
      shift # past argument=value
      ;;
    -kd|--kind)
      install_kind
      shift # past argument=value
      ;;
    -h|--help)
      usage
      shift # past argument=value
      ;;
    -*|--*)
      echo "Unknown option $i"
      usage
      exit 1
      ;;
    *)
      ;;
  esac
done
