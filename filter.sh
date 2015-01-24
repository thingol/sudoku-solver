#!/bin/bash

tr '\n' 'X' < $1 |tr -d ' '|sed -e s/[%]/\\n/g|sed -e s/^[a-zX' '-]*//g|sed -e s/X$//g|tr -d 'X'|tr '.' '0' > ${1}.filtered
