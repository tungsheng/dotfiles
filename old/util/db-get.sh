#!/bin/bash
rm -rf ./tmp
ssh $serv "rm -rf tmp"

# Dump data
ssh $serv "mkdir tmp"
ssh $serv "mongodump -h 127.0.0.1 -d fullinn -o tmp"

# Transfer data to local
scp -r $serv:./tmp .

mv tmp/fullinn tmp/$serv

# Restore database
mongorestore ./tmp --drop

# Clean local and server again
rm -rf ./tmp
ssh $serv "rm -rf tmp"

exit 0
