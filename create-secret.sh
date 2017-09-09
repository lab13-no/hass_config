#!/bin/bash

set -e
cd `dirname $0`

typeset -r SECRETS=$(grep -o \!secret\ .* configuration.yaml |awk '{print $2}')
for item in $SECRETS
do
	echo $item;
	read input
	echo "$item: $input" >> secrets.yaml
done

