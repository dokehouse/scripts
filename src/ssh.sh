#!/bin/bash
set -euo pipefail

# validate ssh public key
validate_ssh_key() {
    local key="$1"
    ssh-keygen -l -f <(echo "$key") &>/dev/null
    return $?
}

# setup ssh directory
SSH_DIR="/root/.ssh"
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"

# get ssh key from user
gum style --foreground 212 "enter your ssh public key:"
# ensure clean input by explicitly reading from /dev/tty
SSH_KEY=$(gum input --width 80 --placeholder "ssh-ed25519 AAAA..." < /dev/tty)

# validate key
if ! validate_ssh_key "$SSH_KEY"; then
    gum style --foreground "#f7768e" "❌ invalid ssh public key"
    exit 1
fi

# add key to authorized_keys
echo "$SSH_KEY" >> "$SSH_DIR/authorized_keys"
chmod 600 "$SSH_DIR/authorized_keys"

# download and apply sshd config
echo "Downloading SSH configuration..."
curl -sSL "https://scripts.doke.house/config/sshd_config" -o "/etc/ssh/sshd_config"
chmod 600 /etc/ssh/sshd_config

# restart ssh service
echo "Restarting SSH service..."
if command -v systemctl &>/dev/null; then
    systemctl restart sshd.service || systemctl restart ssh.service
else
    service sshd restart || service ssh restart
fi

gum style --foreground 212 "✨ ssh configuration complete!"

