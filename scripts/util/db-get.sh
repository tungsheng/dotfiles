#!/bin/bash
source $HOME/.dotfiles/.env
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

exit 0
