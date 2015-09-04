#!/bin/bash

url="http://localhost:9000/"
http_code=`curl -sw "%{http_code}\\n" -o /dev/null ${url}`
response=`curl -s $url`

if test $http_code != 200; then
  printf "FAILURE: HTTP code should be 200, but was ${http_code} instead.\n"
  exit 1
fi

if [[ $response != *"About Shout"* ]]; then
  printf "FAILURE: \"About Shout\" was not found in the HTTP response.\n"
  exit 1
fi

exit 0
