#!/bin/bash

# Get the count of active containers using docker ps command
# container_count=$(docker ps -q | wc -l)

# Get the hostname of the system
host_name=$(hostname)

container_count=$(docker ps --format "table {{.Names}}" | wc -l)
#echo $container_count-1

# Delete old tar files
# rm -rf /tmp/*server01.tar
#find /tmp/ -type f -name "*server01.tar" -mtime +1 -exec rm -rf {} \;
find /tmp/ -type f -name "*$hostname.tar" -mtime -1 -exec rm -rf {} \;



# Loop from 1 to the container count
for ((i=2; i<=$container_count; i++)); do
    # Execute commands or operations for each container
    # container_id=$(docker ps -q | sed -n "$((i-1))p")
    container_name=$(docker ps --format "table {{.Names}}" | sed -n "${i}p")

    # echo "Processing container $i with ID: $container_id"
    # echo "Processing container $i with Name: $container_name"

    # Combine the date/time and hostname

    current_datetime=$(date +"%Y%m%d_%H:%M:%S")
    result="$container_name""_""${current_datetime}""_""${host_name}.tar"

    #echo $result 
    docker export $container_name >/tmp/$result


    # Add more commands or operations here if needed
done

