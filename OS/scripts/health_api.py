#!/usr/bin/env python3
"""
Health Check API for Redeemer Lab
Provides status and health information about the lab environment.
"""

from flask import Flask, jsonify
import subprocess
import socket
import time

app = Flask(__name__)

def check_service_reachable(host, port, timeout=2):
    """Check if a service is reachable on given host and port."""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(timeout)
        result = sock.connect_ex((host, port))
        sock.close()
        return result == 0
    except Exception as e:
        return False

def check_command_exists(command):
    """Check if a command exists in the system."""
    try:
        subprocess.run(['which', command], capture_output=True, check=True)
        return True
    except:
        return False

@app.route('/api/health', methods=['GET'])
def health_check():
    """Basic health check endpoint."""
    return jsonify({
        'status': 'healthy',
        'timestamp': int(time.time()),
        'service': 'os-instance'
    }), 200

@app.route('/api/status', methods=['GET'])
def lab_status():
    """Comprehensive lab status endpoint."""
    
    # Check Redis service
    redis_status = {
        'reachable': check_service_reachable('redis', 6379),
        'service': 'redis',
        'port': 6379
    }
    
    # Check tools availability
    tools = {
        'nmap': check_command_exists('nmap'),
        'redis-cli': check_command_exists('redis-cli'),
        'netcat': check_command_exists('nc'),
        'telnet': check_command_exists('telnet'),
        'curl': check_command_exists('curl')
    }
    
    # Overall lab status
    lab_ready = redis_status['reachable'] and tools['nmap'] and tools['redis-cli']
    
    response = {
        'lab_status': 'ready' if lab_ready else 'not_ready',
        'timestamp': int(time.time()),
        'services': {
            'redis': redis_status
        },
        'tools': tools,
        'os_instance': {
            'status': 'running',
            'vnc_available': True
        }
    }
    
    return jsonify(response), 200

@app.route('/api/info', methods=['GET'])
def lab_info():
    """Lab information and setup details."""
    return jsonify({
        'lab_name': 'Redeemer',
        'lab_type': 'Redis Enumeration Lab',
        'difficulty': 'Very Easy',
        'focus': 'Service enumeration and Redis interaction',
        'target_service': 'Redis',
        'recommended_tools': ['nmap', 'redis-cli'],
        'learning_objectives': [
            'Network service discovery with Nmap',
            'Connecting to exposed Redis instances',
            'Basic Redis command execution',
            'Data enumeration in Redis databases'
        ]
    }), 200

if __name__ == '__main__':
    # Run on all interfaces, port 9001
    app.run(host='0.0.0.0', port=9001, debug=False)
