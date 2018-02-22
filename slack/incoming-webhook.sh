#!/bin/bash

# In advance, set config. see https://api.slack.com/incoming-webhooks

set -x
set -eu

curl -X POST --data-urlencode "payload={\"username\": \"webhookbot\", \"text\": \"This is posted to #general and comes from a bot named webhookbot.\", \"icon_emoji\": \":ghost:\"}" URL

#curl -X POST --data-urlencode "payload={\"channel\": \"#general\", \"username\": \"webhookbot\", \"text\": \"This is posted to #general and comes from a bot named webhookbot.\", \"icon_emoji\": \":ghost:\"}" URL
