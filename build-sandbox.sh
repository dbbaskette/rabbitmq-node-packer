#!/usr/bin/env bash


# Get Vagrant Based Box for Platform
BOX_IMAGE="bento/ubuntu-16.04"
#BOX_IMAGE="ubuntu/trusty64"
PROVIDER="virtualbox"
ATLAS_TOKEN=<ENTER ATLAS TOKEN>
vagrant box add $BOX_IMAGE --provider $PROVIDER
CURRENT_BOX=$(vagrant box list | grep $BOX_IMAGE | grep $PROVIDER | sed '$!d' | sed 's/.*, //' | sed 's/.$//')
BOX_DIR=$(echo $BOX_IMAGE | sed 's/\//-VAGRANTSLASH-/g')
BOX_PATH="$HOME/.vagrant.d/boxes/$BOX_DIR/$CURRENT_BOX/$PROVIDER/box.ovf"
echo $BOX_PATH

# Get Version Number of RabbitMQ that will be installed
export RABBIT_VERSION=$(curl -s http://www.rabbitmq.com/debian/dists/testing/main/binary-i386/Packages | grep Version | cut -c 10-)
echo "RABBIT VERSION: " $RABBIT_VERSION

#  Build the box
packer build -force -var "rabbit_version=$RABBIT_VERSION" -var "box_path=$BOX_PATH" -var "atlas_token=$ATLAS_TOKEN" rabbitmq-sandbox-packer.json