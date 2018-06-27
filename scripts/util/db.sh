#!/bin/sh

ssh fullinn.prod "mongodump -h 127.0.0.1 -d fullinn -o fullinn"
ssh fullinn.prod "tar -zcvf f.tar.gz fullinn/fullinn"
scp root@fullinn.prod:/root/f.tar.gz .
tar -zxvf f.tar.gz
mongorestore -d fullinn --drop fullinn/fullinn



# copy file from/to server
scp -r user@your.server.example.com:/path/to/foo /your/pathname

# connect to server
ssh -l {$username} {$ip}



# mongo shell
mongo --shell

# backup db data
mongodump --db {$db_name} -o {$output_folder_path}

# restore db data
mongorestore {$folder_path} --drop

# mongo db query monitering
mongostat



# MongoShell
# list all dbs
show dbs

# list all collection
show collection

# use specific db
use {$db_name}

# drop specific db
db.dropDatabase()

# remove specific collection
db.{$collection}.drop()

# find query in specific collection
db.{$collection}.find().pretty()



# Docker log
docker log -f {$container_name}



# restart Gitea
# connect to dev
# execute cmd in root
/etc/init.d/gitea restar




rm -rf ./tmp
ssh deploy@$PROD "rm -rf tmp"

# Dump data
ssh deploy@$PROD "mkdir tmp"
ssh deploy@$PROD "mongodump -h 127.0.0.1 -d fullinn -o tmp"

# Transfer data to local
scp -r deploy@$PROD:./tmp .

# Restore database
mongorestore ./tmp --drop

# Clean local and server again
rm -rf ./tmp
ssh deploy@$PROD "rm -rf tmp"

