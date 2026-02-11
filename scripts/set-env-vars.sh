#!/bin/bash
set -e

aws secretsmanager get-secret-value --secret-id coder/ccadogan | jq -r '.SecretString | gsub("\r\n"; "\n")' > $HOME/.env.local

aws secretsmanager get-secret-value --secret-id coder/ccadogan/keys | jq -r .SecretString | jq -r ".id_ed25519" | sed 's/\\n/\n/g' > $HOME/.ssh/id_ed25519
aws secretsmanager get-secret-value --secret-id coder/ccadogan/keys | jq -r .SecretString | jq -r ".id_ed25519_pub" | sed 's/\\n/\n/g' > $HOME/.ssh/id_ed25519.pub
