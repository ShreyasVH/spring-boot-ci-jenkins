DIR=$(pwd)

REPO="spring-boot-unit-test"
HOOK_NAME=web
#curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" -H "Accept: application/vnd.github+json" https://api.github.com/repos/ShreyasVH/$REPO/hooks

printf "Deleting existing hooks\n"
curl -s -u "$GITHUB_USERNAME:$GITHUB_TOKEN" https://api.github.com/repos/$GITHUB_USERNAME/$REPO/hooks | jq -r '.[] | select(.name=="'$HOOK_NAME'") | "\(.id) \(.config.url)"' | while read id url; do
    echo "Deleting webhook $id ($url)"
    curl -s -X DELETE \
      -u "$GITHUB_USERNAME:$GITHUB_TOKEN" \
      https://api.github.com/repos/$GITHUB_USERNAME/$REPO/hooks/$id
  done

#curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" -H "Accept: application/vnd.github+json" https://api.github.com/repos/ShreyasVH/$REPO/hooks

PID_FILE=ngrok.pid

kill -9 $(cat $PID_FILE)
rm $PID_FILE

#start ngrok
export PATH=$HOME/programs/ngrok/$NGROK_VERSION/bin:$PATH
printf "Starting ngrok\n"
ngrok http $JENKINS_PORT > server.log 2>&1 &
PID=$!
echo $PID > $PID_FILE

NGROK_PORT=4040
printf "Waiting for ngrok to start on $NGROK_PORT\n"
while [[ ! $(lsof -i:$NGROK_PORT -t | wc -l) -gt 0 ]];
do
    printf "."
done
printf "\n"

NGROK_URL="http://localhost:$NGROK_PORT/api/tunnels"
printf "Waiting for $NGROK_URL\n"
while true; do
  printf "."
  STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$NGROK_URL")
  if [ "$STATUS_CODE" -eq 200 ]; then
    NGROK_PUBLIC_URL=$(curl -fsS $NGROK_URL | jq -r '.tunnels[]? | select(.proto=="https") | .public_url' | head -n 1)

    if [[ -n "$NGROK_PUBLIC_URL" && "$NGROK_PUBLIC_URL" != "null" ]]; then
      break
    fi
  fi
  sleep 2
done
echo ""

echo $NGROK_PUBLIC_URL

CREATE_HOOK_RESPONSE=$(curl -s -X POST \
  -u "$GITHUB_USERNAME:$GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/$GITHUB_USERNAME/$REPO/hooks \
  -d "{
    \"name\": \"$HOOK_NAME\",
    \"active\": true,
    \"events\": [\"push\"],
    \"config\": {
      \"url\": \"$NGROK_PUBLIC_URL/github-webhook/\",
      \"content_type\": \"json\"
    }
  }")


#curl -u "$GITHUB_USERNAME:$GITHUB_TOKEN" -H "Accept: application/vnd.github+json" https://api.github.com/repos/ShreyasVH/$REPO/hooks
