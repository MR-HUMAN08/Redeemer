# 🌐 Web Landing Page - Complete!

## ✅ Successfully Deployed!

Your Redeemer lab now has a professional HTB-style landing page!

---

## 🎨 Features

### **Red & Black Theme**
- Professional HTB-inspired design
- Scanline effects and glowing elements
- Animated status indicators
- Responsive layout

### **Lab Information**
- Mission brief
- Learning objectives
- Available tools
- Quick start commands
- Security warning

### **Embedded OS Instance**
- Click "START OS INSTANCE" button
- OS loads inline in the browser (like HTB)
- Fullscreen mode available
- New window option
- Easy close (ESC key or button)

---

## 🚀 Access Now

**Open your browser and go to:**

## 🔗 http://localhost:8080

---

## 🎮 How It Works

1. **Landing Page** (http://localhost:8080)
   - Shows lab overview
   - Red/black themed interface
   - "START OS INSTANCE" button

2. **Click Start Button**
   - OS instance loads in iframe
   - noVNC embedded at http://localhost:6080
   - Full screen available
   - Controls: Fullscreen, New Window, Close

3. **Start Hacking**
   - Desktop loads inline
   - Open terminal
   - Begin enumeration
   - Press ESC to return to landing page

---

## 📊 Status Check

Current services:

```bash
✅ Web Landing Page:  http://localhost:8080
✅ Desktop (direct):  http://localhost:6080
✅ Health API:        http://localhost:9001/api/status
✅ Redis Target:      localhost:6379
```

Verify:
```bash
curl http://localhost:8080 | grep REDEEMER
docker compose ps
```

---

## 🎨 Customization

### Change Colors
Edit `web/index.html` CSS variables:
- `#ff0000` = Red color
- `#000000` = Black background
- Adjust gradients and shadows

### Modify Content
Edit `web/index.html` sections:
- Mission brief
- Learning objectives
- Tools list
- Getting started commands

### Add Features
- Additional info sections
- More buttons/controls
- Status indicators
- Timer/progress tracking

---

## 🔧 Technical Details

**Stack:**
- Pure HTML/CSS/JavaScript
- Nginx Alpine (lightweight)
- noVNC embedded via iframe
- No external dependencies

**Container:**
- Name: `redeemer-web`
- Port: 8080
- Image: nginx:alpine
- Auto-restart enabled

**Files:**
```
web/
├── Dockerfile      # Nginx container
├── nginx.conf      # Web server config
├── index.html      # Landing page (16KB)
└── README.md       # Documentation
```

---

## 🎯 User Experience

### Students See:
1. Professional landing page
2. Clear mission briefing
3. Learning objectives
4. Available tools
5. Quick start guide
6. One-click OS launch

### HTB-Style Elements:
- ✅ Red/black color scheme
- ✅ Terminal-style fonts
- ✅ Glowing effects
- ✅ Status indicators
- ✅ Inline OS instance
- ✅ Professional UI

---

## 📸 What It Looks Like

### Landing Page:
```
┌─────────────────────────────────────┐
│         🔴 REDEEMER 🔴            │
│   Redis Enumeration Challenge       │
│  [VERY EASY] [ENUMERATION] [REDIS] │
├─────────────────────────────────────┤
│                                     │
│  > MISSION BRIEF                    │
│    Locate and enumerate Redis...   │
│                                     │
│  > LEARNING OBJECTIVES              │
│    ▸ Perform network recon          │
│    ▸ Identify Redis services        │
│    ▸ Execute Redis commands         │
│                                     │
│  > TOOLS AVAILABLE                  │
│    ▸ nmap, redis-cli, netcat       │
│                                     │
│  > GETTING STARTED                  │
│    $ nmap -sn 172.20.0.0/16        │
│    $ redis-cli -h <target>         │
│                                     │
│  [🔴 START OS INSTANCE]           │
└─────────────────────────────────────┘
```

### OS View (After Click):
```
┌─────────────────────────────────────┐
│ 🔴 REDEEMER - OS ACTIVE             │
│ [⛶ Fullscreen] [↗ New] [✕ Close]  │
├─────────────────────────────────────┤
│                                     │
│   [Debian Desktop Loads Here]      │
│   [Full noVNC Interface]           │
│   [Terminal, Firefox, Tools]       │
│                                     │
└─────────────────────────────────────┘
```

---

## 🎓 For Instructors

### Give Students:
```
Access the Redeemer Lab:
http://your-server-ip:8080

Instructions:
1. Click "START OS INSTANCE"
2. Wait for desktop to load
3. Open terminal
4. Follow the lab guide
```

### Benefits:
- ✅ Professional first impression
- ✅ Clear expectations
- ✅ Easy access
- ✅ No confusion
- ✅ Looks like real CTF platform

---

## 🚦 Quick Commands

```bash
# View web logs
docker logs redeemer-web

# Restart web service
docker compose restart web

# Rebuild web (after changes)
docker compose build web
docker compose up -d web

# Access directly
curl http://localhost:8080

# Full restart
docker compose down
docker compose up -d
```

---

## ✨ What Changed

**Added:**
- `/web/` directory with landing page
- Web service in docker-compose.yml
- Port 8080 for web interface
- HTB-style UI with red/black theme
- Embedded OS instance
- Professional lab presentation

**Updated:**
- All scripts mention http://localhost:8080
- Documentation references new landing page
- Status checks include web service

**No Breaking Changes:**
- Direct access still works: http://localhost:6080
- All existing functionality preserved
- Redis and OS unchanged

---

## 🎉 Ready to Use!

**Everything is deployed and working!**

Open: http://localhost:8080
Click: "START OS INSTANCE"
Hack: Complete the challenge!

---

**Enjoy your professional HTB-style lab! 🔴⚫**
