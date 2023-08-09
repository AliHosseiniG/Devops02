#!/bin/bash

# create a variable to show 24 hours ago
time_24_hours_ago=$(date -u -d "24 hours ago" "+%Y-%m-%dT%H:%M:%S")

# numer of running_nginx container
number_of_nginx=$(docker ps | grep nginx | awk '{print $1}' | wc -l)

# if there is no enginx container show error and exit
if [ -z "$number_of_nginx" ]; then
   echo 'there is no running NGINX container!'
   exit 1
fi

# if there exist more than one nginx container
# show no of Ips for every nginx
for ((i=1; i<=$number_of_nginx; i++)); do
	
	# extract container id and ip
	container_id=$(docker ps | grep nginx | awk '{print $1}' | sed -n "${i}p")
	container_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $container_id)

	# extract ip addresses that are connected
	total_count=$(docker logs $container_id | awk '/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {print $1}' | sort | uniq | wc -l)
	Last_24H_count=$(docker logs --since $time_24_hours_ago $container_id | awk '/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/ {print $1}' | sort | uniq | wc -l)
	generate_date=$(date "+%Y-%m-%d %H:%M:%S")

	# show the results
	echo   # blank line
	echo "NGINX IP: $container_IP"
	echo "***************************************************"
	echo "Total number of connected: $total_count"
	echo "Number of connections in the last 24 hours: $Last_24H_count"

	# save the output in a file in a column format:
	# DATE TIME  Webserver_IP  COUNT
	
	# create out file, if there is not exist!
        if [ -z $(find . -name "output.txt") ]; then
            
            # create a title for every column in output file		
	    echo -e "DateTime\t\tSite_IP\t\tCOUNT" > output.txt
	fi
	
	echo -e "$generate_date\t$container_IP\t$Last_24H_count" >> output.txt
	
done

