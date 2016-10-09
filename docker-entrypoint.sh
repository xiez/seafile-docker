#!/usr/bin/env bash

echo "now start services..."
if [[ $1 == "bash" ]]; then
    /bin/bash
else
    echo "start nginx..."
    service nginx start
    echo "start mysql..."
    service mysql start
    echo "restart seafile server"
    service seafile-server restart
fi

