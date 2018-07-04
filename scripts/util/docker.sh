

# Remove all exited containers

# List:
docker ps -a -f status=exited

# Remove:
docker rm $(docker ps -a -f status=exited -q)


# udpate time
ntpdate -s time.stdtime.gov.tw
