# Debian + Xfce + TigerVNC + noVNC (Browser-based VNC Desktop)
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    VNC_PASSWORD=debian \
    USERNAME=debian

# Install desktop, VNC, noVNC, nginx, supervisor, and essential utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    # Desktop environment
    xfce4 xfce4-session xfce4-terminal \
    # VNC server
    tigervnc-standalone-server tigervnc-common tigervnc-tools \
    # X11 utilities
    dbus-x11 x11-xserver-utils \
    # Core utilities
    python3 python3-pip git wget ca-certificates \
    supervisor sudo procps locales curl vim \
    # Web server for noVNC
    nginx \
    python3-flask \
    # Web browser
    firefox-esr \
    # Security and networking tools
    nmap \
    redis-tools \
    netcat-traditional \
    telnet \
    dnsutils \
    iputils-ping \
    traceroute \
    dig \
    nslookup \
    whois \
    net-tools \
    # Text processing (less is separate package)
    less \
    # Clipboard support
    xclip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Clone noVNC and websockify
RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/noVNC \
    && git clone --depth 1 https://github.com/novnc/websockify.git /opt/noVNC/utils/websockify \
    && pip3 install --break-system-packages websockify

# Create non-root user with sudo privileges
RUN useradd -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME}

# Setup VNC xstartup to launch Xfce desktop
RUN mkdir -p /home/${USERNAME}/.vnc && \
    echo '#!/bin/bash' > /home/${USERNAME}/.vnc/xstartup && \
    echo 'unset SESSION_MANAGER' >> /home/${USERNAME}/.vnc/xstartup && \
    echo 'unset DBUS_SESSION_BUS_ADDRESS' >> /home/${USERNAME}/.vnc/xstartup && \
    echo 'export XKL_XMODMAP_DISABLE=1' >> /home/${USERNAME}/.vnc/xstartup && \
    echo 'export XDG_CURRENT_DESKTOP="XFCE"' >> /home/${USERNAME}/.vnc/xstartup && \
    echo 'export XDG_SESSION_DESKTOP="xfce"' >> /home/${USERNAME}/.vnc/xstartup && \
    echo 'export DESKTOP_SESSION="xfce"' >> /home/${USERNAME}/.vnc/xstartup && \
    echo 'xrdb $HOME/.Xresources 2>/dev/null || true' >> /home/${USERNAME}/.vnc/xstartup && \
    echo '/usr/bin/startxfce4 &' >> /home/${USERNAME}/.vnc/xstartup && \
    echo 'wait' >> /home/${USERNAME}/.vnc/xstartup && \
    chmod +x /home/${USERNAME}/.vnc/xstartup && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.vnc

# Create desktop shortcuts
RUN mkdir -p /home/${USERNAME}/Desktop && \
    # Firefox shortcut
    echo '[Desktop Entry]' > /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'Version=1.0' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'Name=Firefox Web Browser' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'Comment=Browse the World Wide Web' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'GenericName=Web Browser' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'Exec=firefox %u' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'Terminal=false' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'Type=Application' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'Icon=firefox' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    echo 'Categories=Network;WebBrowser;' >> /home/${USERNAME}/Desktop/Firefox.desktop && \
    chmod +x /home/${USERNAME}/Desktop/Firefox.desktop && \
    # Terminal shortcut
    echo '[Desktop Entry]' > /home/${USERNAME}/Desktop/Terminal.desktop && \
    echo 'Version=1.0' >> /home/${USERNAME}/Desktop/Terminal.desktop && \
    echo 'Name=Terminal' >> /home/${USERNAME}/Desktop/Terminal.desktop && \
    echo 'Comment=Use the command line' >> /home/${USERNAME}/Desktop/Terminal.desktop && \
    echo 'TryExec=xfce4-terminal' >> /home/${USERNAME}/Desktop/Terminal.desktop && \
    echo 'Exec=xfce4-terminal' >> /home/${USERNAME}/Desktop/Terminal.desktop && \
    echo 'Icon=utilities-terminal' >> /home/${USERNAME}/Desktop/Terminal.desktop && \
    echo 'Type=Application' >> /home/${USERNAME}/Desktop/Terminal.desktop && \
    echo 'Categories=System;TerminalEmulator;' >> /home/${USERNAME}/Desktop/Terminal.desktop && \
    chmod +x /home/${USERNAME}/Desktop/Terminal.desktop && \
    chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/Desktop

# Configure nginx to serve noVNC on port 80
RUN rm -f /etc/nginx/sites-enabled/default && \
    echo 'server {' > /etc/nginx/sites-available/novnc && \
    echo '    listen 80 default_server;' >> /etc/nginx/sites-available/novnc && \
    echo '    listen [::]:80 default_server;' >> /etc/nginx/sites-available/novnc && \
    echo '    server_name _;' >> /etc/nginx/sites-available/novnc && \
    echo '    root /opt/noVNC;' >> /etc/nginx/sites-available/novnc && \
    echo '    index vnc.html;' >> /etc/nginx/sites-available/novnc && \
    echo '' >> /etc/nginx/sites-available/novnc && \
    echo '    location / {' >> /etc/nginx/sites-available/novnc && \
    echo '        try_files $uri $uri/ /vnc.html;' >> /etc/nginx/sites-available/novnc && \
    echo '    }' >> /etc/nginx/sites-available/novnc && \
    echo '' >> /etc/nginx/sites-available/novnc && \
    echo '    location /websockify {' >> /etc/nginx/sites-available/novnc && \
    echo '        proxy_pass http://localhost:6080/;' >> /etc/nginx/sites-available/novnc && \
    echo '        proxy_http_version 1.1;' >> /etc/nginx/sites-available/novnc && \
    echo '        proxy_set_header Upgrade $http_upgrade;' >> /etc/nginx/sites-available/novnc && \
    echo '        proxy_set_header Connection "upgrade";' >> /etc/nginx/sites-available/novnc && \
    echo '        proxy_set_header Host $host;' >> /etc/nginx/sites-available/novnc && \
    echo '        proxy_set_header X-Real-IP $remote_addr;' >> /etc/nginx/sites-available/novnc && \
    echo '        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' >> /etc/nginx/sites-available/novnc && \
    echo '        proxy_set_header X-Forwarded-Proto $scheme;' >> /etc/nginx/sites-available/novnc && \
    echo '    }' >> /etc/nginx/sites-available/novnc && \
    echo '}' >> /etc/nginx/sites-available/novnc && \
    ln -s /etc/nginx/sites-available/novnc /etc/nginx/sites-enabled/novnc

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && sed -i 's/\r$//' /entrypoint.sh

EXPOSE 80

USER root
CMD ["/entrypoint.sh"]