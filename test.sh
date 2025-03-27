PIPELINE_NAME="it-basic"

echo "Getting build definition ID for pipeline '$PIPELINE_NAME'..."

DEF_RESULTS=$(curl -s -H "Authorization: Basic $(echo -n ":DdFlPB9NPTeQ61mQWdqJLaFO2NkJnppkWMlhpm3UxckwkkEzzCqxJQQJ99BCACAAAAAAArohAAASAZDO3tdx" | base64 -w0)" \
"https://dev.azure.com/gha-azure-pipelines-testing/integration-tests/_apis/build/definitions?name=$PIPELINE_NAME")

if [ $(echo "$DEF_RESULTS" | jq .count) -gt 1 ]; then
    echo "Error: More than one pipeline found with name '$PIPELINE_NAME'."
    exit 1
elif [ $(echo "$DEF_RESULTS" | jq .count) -eq 0 ]; then
    echo "Error: No pipeline found with name '$PIPELINE_NAME'."
    exit 1
else
    BUILD_DEFINITION_ID=$(echo "$DEF_RESULTS" | jq -r '.value[0].id')
    echo "Build definition ID for pipeline '$PIPELINE_NAME' is $BUILD_DEFINITION_ID."
    PIPELINE_ID=$(echo "$DEF_RESULTS" | jq -r '.value[0].id')
fi


echo "Getting current build count for pipeline ID $PIPELINE_ID"

BUILD_COUNT=$(curl -s -H "Authorization: Basic $(echo -n ":DdFlPB9NPTeQ61mQWdqJLaFO2NkJnppkWMlhpm3UxckwkkEzzCqxJQQJ99BCACAAAAAAArohAAASAZDO3tdx" | base64 -w0)" \
"https://dev.azure.com/gha-azure-pipelines-testing/integration-tests/_apis/build/builds?api-version=6.0&definitions=$PIPELINE_ID&queryOrder=queueTimeDescending&\$top=1" | \
jq '.value[0].id' | \)

echo "CURRENT_BUILD_COUNT=$BUILD_COUNT" >> $GITHUB_ENV
echo "Current build count: $BUILD_COUNT"