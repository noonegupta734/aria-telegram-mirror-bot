#!/bin/bash

if [[ -n $SA_ZIP_URL ]]; then
	echo "Usage of Service Accounts Detected"
	wget -q $SA_ZIP_URL -O /bot/accounts.zip && unzip -qq -o accounts.zip
elif [[ -n $CLIENT_SECRET && -n $CREDENTIALS ]]; then
	echo "Usage of token detected"
	wget -q $CREDENTIALS -O /bot/credentials.json
	wget -q $CLIENT_SECRET -O /bot/client_secret.json
else
	echo "Neither Service Accounts Nor Token Provided. Exiting..."
	exit 0
fi

if [[ -n $CONFIG_URL ]]; then
	wget -q $CONFIG_URL -O /bot/out/.constants.js
else
	echo "Provide constants.js to Run the bot. Exiting..."
	exit 0
fi
tracker_list=`curl -Ns https://raw.githubusercontent.com/XIU2/TrackersListCollection/master/all.txt | awk '$1' | tr '\n' ',' | cat`
if [[ -n $MAX_CONCURRENT_DOWNLOADS ]]; then
	echo -e "\nmax-concurrent-downloads=$MAX_CONCURRENT_DOWNLOADS\nbt-tracker=$tracker_list" >> /bot/aria.conf
else
	echo -e "\nmax-concurrent-downloads=3\nbt-tracker=$tracker_list" >> /bot/aria.conf
fi

aria2c --conf-path=aria.conf
npm start