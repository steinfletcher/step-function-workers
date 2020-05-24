#!/bin/bash

mkdir -p build

for f in cmd/*/; do
    if [[ -d "$f" ]]; then
        function_name="$(echo $f | sed 's;cmd;;g' | sed 's;/;;g')"

        echo "Building '${function_name}' function"
        GOOS=linux go build -o function cmd/${function_name}/main.go

        echo "Creating '${function_name}' artifact"
        zip ${function_name}.zip function

        mkdir -p build/${function_name}
        mv ${function_name}.zip build/${function_name}/function.zip
        rm -f ${function_name}
        rm -f function
    fi
done
