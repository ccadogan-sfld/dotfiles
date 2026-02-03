#!/bin/bash
set -e

aws secretsmanager get-secret-value --secret-id coder/ccadogan | jq -r .SecretString > $HOME/.env.local
