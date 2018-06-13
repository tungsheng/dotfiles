#!/bin/sh

ssh fullinn.prod "mongodump -h 127.0.0.1 -d fullinn -o fullinn"
ssh fullinn.prod "tar -zcvf f.tar.gz fullinn/fullinn"
scp root@fullinn.prod:/root/f.tar.gz .
tar -zxvf f.tar.gz
mongorestore -d fullinn --drop fullinn/fullinn
