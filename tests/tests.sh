#!/bin/bash

set -e

# See http://stackoverflow.com/a/21189044/1935861
parse_yaml () {
  prefix=$2
  s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
  sed -ne "s|^\($s\):|\1|" \
      -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
      -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
  awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
        vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
        printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

url="http://localhost:9000/"
http_code=`curl -sw "%{http_code}\\n" -o /dev/null ${url}`
response=`curl -s $url`

# TODO: Verify version of The Lounge in CLI stdout

if test $http_code != 200; then
  printf "FAILURE: HTTP code should be 200, but was ${http_code} instead.\n"
  exit 1
fi

if [[ $response != *"<title>The Lounge</title>"* ]]; then
  printf "FAILURE: \"<title>The Lounge</title>\" was not found in the HTTP response.\n"
  exit 1
fi

exit 0
