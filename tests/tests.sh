#!/bin/sh

# See http://stackoverflow.com/a/21189044/1935861
function parse_yaml {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
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

# Extract lounge_version from the defaults
eval $(parse_yaml defaults/main.yml | grep 'lounge_version')

if test $http_code != 200; then
  printf "FAILURE: HTTP code should be 200, but was ${http_code} instead.\n"
  exit 1
fi

if [[ $response != *"The Lounge is in version <strong>$lounge_version</strong>"* ]]; then
  printf "FAILURE: \"The Lounge is in version <strong>$lounge_version</strong>\" was not found in the HTTP response.\n"
  exit 1
fi

exit 0
