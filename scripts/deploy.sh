#!/usr/bin/env bash

artifacts_s3_bucket_name="stein-lambda-artifacts"

for f in cmd/*/; do
    if [[ -d "$f" ]]; then
        function_name="$(echo $f | sed 's;cmd;;g' | sed 's;/;;g')"

        echo "Copying '${function_name}.zip' to S3"
        aws s3 cp build/${function_name}/function.zip s3://${artifacts_s3_bucket_name}/${function_name}/function.zip --region eu-west-1

        echo "Updating '${function_name}' function code"
        aws lambda update-function-code --function-name ${function_name} --s3-bucket ${artifacts_s3_bucket_name} --s3-key ${function_name}/function.zip --region eu-west-1
    fi
done
