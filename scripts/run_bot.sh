#!/bin/bash

# ---- START INSTALL DEPENDENCIES

sudo apt update -y

is_installed() {
  command -v "$1" >/dev/null 2>&1
}

dependencies=("psql" "libpq-dev" "nvm" "npm" "pnpm" "pm2" "python3" "pip3")

is_installed() {
  dpkg -l | grep -q "$1"
}

for package in "${dependencies[@]}"; do
  if ! is_installed "$package"; then
    echo "$package is not installed. installing"
    sudo apt-get update
    sudo apt-get install -y "$package"
    sleep 1
  else
    echo "$package is already installed"
  fi
done
# ---- END INSTALL DEPENDENCIES

# ---- START BOTS

### stop all run pm2
pm2 stop all

cd ~/kiyunapay-discord-bot
pnpm build
sleep 0.5
cd ~/kiyunapay-telegram-bot
make rm
pip3 install -r requirements.txt
sleep 0.5
cd

pm2 start ecosystem.config.js

# ---- END BOTS

echo "scripts run OK."

