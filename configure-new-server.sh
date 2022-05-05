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
  echo "      -jk (--jenkins): installs jenkins"
  echo "      -f2b (--fail2ban): installs fail2ban"
  echo "      -nx (--nginx): installs nginx"
  echo "      -helm (--helm): installs helm"
  echo "      -java (--java): installs java"
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

install_jenkins(){
  echo "----- Installing Jenkins..."
  sudo apt update
  install_java

  wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
  sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  sudo apt update

  echo "jenkins ALL= NOPASSWD: ALL" | sudo tee -a /etc/sudoers

  sudo apt install jenkins -y
  sudo systemctl start jenkins
}

install_fail2ban(){
  echo "----- Installing fail2ban..."
  sudo apt update
  sudo apt install fail2ban -y
  sudo service fail2ban start
  echo "----- fail2ban installed!"
}

install_nginx(){
  echo "----- Installing Nginx..."
  sudo apt update
  sudo apt install nginx -y
  sudo cp nginx.conf /etc/nginx/nginx.conf
  sudo nginx -t
  sudo systemctl restart nginx
  echo "----- Nginx installed!"
}

install_helm(){
  echo "----- Installing Helm..."
  sudo snap install helm --classic
  echo "----- Helm installed!"
}

install_java(){
  echo "----- Installing Java..."
  sudo apt install default-jre -y
  sudo apt install default-jdk -y
  echo "----- Java installed!"
}

install_all(){
  install_docker
  install_kubectl
  install_kind
  install_jenkins
  install_fail2ban
  install_nginx
  install_helm
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
    -jk|--jenkins)
      install_jenkins
      shift # past argument=value
      ;;
    -f2b|--fail2ban)
      install_fail2ban
      shift # past argument=value
      ;;
    -nx|--nginx)
      install_nginx
      shift # past argument=value
      ;;
    -helm|--helm)
      install_helm
      shift # past argument=value
      ;;
    -java|--java)
      install_java
      shift # past argument=value
      ;;
    -all|--all)
      install_all
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
