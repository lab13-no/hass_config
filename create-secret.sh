#!/bin/bash
SECRETS=$(cat configuration.yaml | grep -o "\!secret .*" | awk '{print $2}')
for item in $SECRETS
do
	echo $item;
	read input
	echo "$item: $input" >> secrets.yaml
done


