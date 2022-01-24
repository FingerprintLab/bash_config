#!/bin/bash

arg=$1
[ -z $arg ] && cd .. && return 0

re='^[0-9]+$'
if ! [[ $arg =~ $re ]] ; then
   echo "error: $arg is not a number" >&2; return 1
else
    while [ "$arg" -gt 0 ]; do
        cd ..
        arg=$(expr $arg - 1 )
    done
fi
return 0
