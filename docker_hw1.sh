#!/bin/bash

# Get the hostname of the system
host_name=$(hostname)

# Get the count of active containers using container names
# container_count=$(docker ps -q | wc -l)
container_count=$(docker ps --format "table {{.Names}}" | wc -l)

# Delete old tar files
find /tmp/ -type f -name "*$hostname.tar" -mtime +1 -exec rm -rf {} \;

# Loop for each container
# first docker ps output is column name, because of this, loop is from 2
for ((i=2; i<=$container_count; i++)); do
    
    # Extract container name 
    container_name=$(docker ps --format "table {{.Names}}" | sed -n "${i}p")


    # Combine the date/time and hostname
    current_datetime=$(date +"%Y%m%d_%H:%M:%S")

    result="$container_name""_""${current_datetime}""_""${host_name}.tar"

    #export container as a tar file in /tmp/ 
    docker export $container_name >/tmp/$result

done
