#!/bin/bash
#
# Connect to random vpn endpoint
#
# Required environment variables:
#  - purevpn_username
#  - purevpn_password
#  - purevpn_location

set -e

MAIN_INIT_FILE="/etc/init.d/purevpn"
ALT_INIT_FILE="/usr/lib/purevpn/purevpn.init"


USER=${USER:-root}
if [ "$USER" != "root" ]; then
    HOME=/home/$USER
fi


# verify PureVPN installed
if ! which purevpn > /dev/null; then
    echo "ERROR: purevpn package is missing"
    exit 2
fi

if [[ -f $MAIN_INIT_FILE ]];then
    INIT_FILE=$MAIN_INIT_FILE
    SERVICE_COMMAND="service purevpn"
fi

if [[ -f $ALT_INIT_FILE ]];then
    INIT_FILE=$ALT_INIT_FILE
    SERVICE_COMMAND=$ALT_INIT_FILE
    chmod +x $ALT_INIT_FILE
fi

sed -i 's/-z  $PID/-z $PID/g' $INIT_FILE
sed -i 's/-z $PID/-z "$PID"/g' $INIT_FILE

ORIG_IP=$(curl -s 'icanhazip.com')
echo "Current IP: ${ORIG_IP}"

# start purevpn service
$SERVICE_COMMAND start
purevpn --logout


# login to purevpn
expect <<EOD
spawn purevpn --login
expect "Username:"
send "${purevpn_username}\r"
expect "Password:"
send "${purevpn_password}\r"
expect #
EOD

# get all location codes
# LOCATIONS=$(purevpn --location | grep -o -E '[A-Z]{2}')
# ARRAY=(${LOCATIONS//:/ })
# LEN=${#ARRAY[@]}

# select random one
# RANDOM_LOCATION=${ARRAY[$((RANDOM % $LEN))]}
LOCATION=${purevpn_location}

# connect
echo "Connecting to ${LOCATION}..."
purevpn --connect "${LOCATION}"

# fix resolve
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "DNS: `cat /etc/resolv.conf`"
NEW_IP=$(curl -s 'icanhazip.com')
echo "Original IP: ${ORIG_IP}"
echo "New IP (${LOCATION}): ${NEW_IP}"