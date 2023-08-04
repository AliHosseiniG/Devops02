#!/bin/bash


# numer of running_nginx container
number_of_nginx=$(docker ps | grep nginx | awk '{print $1}' | wc -l)

# only one nginx container is allowded
if [ -z "$number_of_nginx" ]; then
   echo 'there is no active NGINX container!'
   exit 1
elif [ "$number_of_nginx" -gt 1 ]; then
   echo 'more than one NGINX container.'
   exit 1
fi

container_id=$(docker ps | grep nginx | awk '{print $1}')

# create a variable to show 24 hours ago
time_24_hours_ago=$(date -u -d "24 hours ago" "+%Y-%m-%dT%H:%M:%S")

total_count=$(docker logs $container_id | awk '/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {print $1}' | sort | uniq | wc -l)
Last_24H_count=$(docker logs --since $time_24_hours_ago $container_id | awk '/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {print $1}' | sort | uniq | wc -l)

container_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)

 
echo "Total number of ip addresses that connected to $container_IP: $total_count"
echo "No of connections to $container_IP in the last 24 hours : $Last_24H_count"

