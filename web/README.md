# Web Landing Page

This directory contains the web interface for the Redeemer lab.

## Purpose

Provides a professional HTB-style landing page that:
- Shows lab information and objectives
- Embeds the OS instance in the browser
- Red/black themed interface

## Structure

```
web/
├── Dockerfile      # Nginx container build
├── nginx.conf      # Nginx configuration
├── index.html      # Landing page
└── README.md       # This file
```

## Access

Once deployed, access the landing page at:
**http://localhost:8080**

Click "START OS INSTANCE" to launch the desktop environment inline.

## Features

- **Professional UI** - HTB-inspired red/black theme
- **Lab Information** - Mission brief, objectives, tools
- **Embedded OS** - Click button to load noVNC in iframe
- **Controls** - Fullscreen, new window, close options
- **Responsive** - Works on different screen sizes
- **Keyboard Shortcuts** - Press ESC to exit OS view

## Technology

- Pure HTML/CSS/JavaScript (no frameworks)
- Nginx for static file serving
- noVNC embedded via iframe

## Customization

Edit `index.html` to:
- Change lab description
- Add more hints
- Modify objectives
- Update styling
