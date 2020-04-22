#!/bin/bash
echo 'ECS_CLUSTER=${CLUSTER_NAME}' > /etc/ecs/ecs.config
start ecs
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
sudo start amazon-ssm-agent
