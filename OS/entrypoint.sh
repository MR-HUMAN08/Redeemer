#!/usr/bin/env bash
set -e

USERNAME=${USERNAME:-debian}

# Ensure locale
if ! locale -a | grep -q en_US.utf8; then
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
  locale-gen
fi

# VNC password setup removed - using SecurityTypes None for passwordless access
mkdir -p /home/${USERNAME}/.vnc

# Ensure ownership
chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

# Test nginx configuration
nginx -t

# Start supervisord (this will start VNC, websockify, and nginx)
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
