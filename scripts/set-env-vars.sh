#!/bin/bash
set -e

aws secretsmanager get-secret-value --secret-id coder/ccadogan | jq -r '.SecretString | gsub("\r\n"; "\n")' > $HOME/.env.local
