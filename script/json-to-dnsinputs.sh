#!/usr/bin/env bash

set -e

# script to process the input-json files and get DNS entries data

JSON_DIR="examples/exercise/input-json"

ARRJ=()

for i in `ls $JSON_DIR`; {
  # The file
  ## echo $i

  # Extract the name of the file
  name=$(echo $i | cut -d'.' -f1)

  # Validate: the extention of the file is json?
  ## echo $i | cut -d'.' -f2

  # Validate: if the json file is good 
  cat $JSON_DIR/$i | jq empty
  
  # add to the json
  jentry=$(cat $JSON_DIR/$i | jq --arg data ${name} '. + {"name": $data}')

  # process to map file
  #echo $jentry| jq -s -r 'to_entries | map("\(.key)=\(.value|tostring)") | .[]'
  ARRJ+=$(echo $jentry | jq .)
}

jq -n '{"addresses": "1.1.1.1", "ttl": "300", "zone": "example.com.", "dns_record_type": "a", "name": "www"}'

##echo $test | jq .