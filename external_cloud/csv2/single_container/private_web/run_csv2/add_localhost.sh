#!/bin/bash

LINE='172.28.5.1      localhost'; FILE=/etc/hosts; grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
