#!/bin/bash
#ddev-generated

# =============================================================================
# Beads DDEV Entrypoint
# =============================================================================

# --- Set up SSH server for AI container access ---
SSH_KEY_DIR="/var/www/html/.ddev/.agent-ssh-keys"

if [ -f "$SSH_KEY_DIR/id_ed25519.pub" ]; then
  mkdir -p ~/.ssh && chmod 700 ~/.ssh
  cp "$SSH_KEY_DIR/id_ed25519.pub" ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys
fi

# Save environment for SSH sessions and start sshd
env | grep -E '^(DDEV_|IS_DDEV_PROJECT|HOME=|PATH=|LANG|TZ=)' \
    | sed 's/^/export /' | sudo tee /etc/ddev-env > /dev/null
sudo chmod 644 /etc/ddev-env
sudo /usr/sbin/sshd 2>/dev/null || true

exec "$@"
