#!/usr/bin/env bash

if [[ $1 == "bash" ]]; then
    /bin/bash
else
    service mysql start
    service seafile-server start
    nginx -g "daemon off;"
fi

