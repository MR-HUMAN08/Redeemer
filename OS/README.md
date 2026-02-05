# OS Container - Nmap Exercise Environment

## Build Commands

### Build the Docker Image
```bash
docker build -t os-container-single-port .
# use sudo incase of linux env
```

### Run the Container
```bash
docker run -d \
  --name letushack-OS \
  -p 6080:6080 \
  -p 5900:5900 \
  --cap-add=NET_ADMIN \
  --cap-add=NET_RAW \
  os-container-single-port
```

### View Container Logs
```bash
docker logs letushack-OS
```

### Stop Container
```bash
docker stop letushack-OS
docker rm letushack-OS
```