#!/usr/bin/env bash



# Install RabbitMQ

echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
sudo apt-get update
sudo apt-get -y --force-yes install rabbitmq-server jq

# Install VBox Guest Additions
sudo apt-get -y --force-yes install linux-generic linux-image-generic linux-headers-generic  virtualbox-guest-additions-iso


# Enable Plugins
sudo rabbitmq-plugins enable rabbitmq_management

# Create Rabbit user
sudo rabbitmqctl add_user $2 $3
sudo rabbitmqctl set_user_tags $2 administrator
sudo rabbitmqctl set_permissions -p / $2 ".*" ".*" ".*"
sudo rabbitmqctl list_users



# Make Login Banner
os_version=$(cat /etc/os-release | grep PRETTY | cut -c 14- | sed 's/."//')
sudo sh -c 'echo "    " > /etc/motd'
sudo sh -c 'echo "#  #" >> /etc/motd'
sudo sh -c 'echo "#  #" >> /etc/motd'
sudo sh -c "echo \"#######      RabbitMQ $4\" >> /etc/motd"
sudo sh -c "echo \"#### ##      $os_version\" >> /etc/motd"
sudo sh -c 'echo "#######       vagrant/vagrant">> /etc/motd'
sudo sh -c 'echo "  \n\n  " >> /etc/motd'

sudo sh -c "echo \"Welcome to the RabbitMQ $4 on Ubuntu $os_version (vagrant/vagrant)\n\" >> /etc/issue"
sudo chmod -x /etc/update-motd.d/*


# Clean Up
sudo apt-get autoremove -y
sudo apt-get clean
sudo rm -f /home/vagrant/*.iso
sudo wget -O "/tmp/zero_machine.sh" http://dev2.hortonworks.com.s3.amazonaws.com/stuff/zero_machine.sh
sudo chmod +x /tmp/zero_machine.sh
sudo /tmp/zero_machine.sh
sudo /bin/rm -f /tmp/zero_machine.sh

