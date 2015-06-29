#!/bin/sh

logit "\n"
info "2 - Docker Daemon Configuration"

# 2.1
check_2_1="2.1  - Do not use lxc execution driver"
pgrep -lf docker | grep lxc >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_2_1"
else
  pass "$check_2_1"
fi

# 2.2
check_2_2="2.2  - Restrict network traffic between containers"
pgrep -lf docker | grep "icc=false" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  pass "$check_2_2"
else
  warn "$check_2_2"
fi

# 2.3
check_2_3="2.3  - Set the logging level"
pgrep -lf docker | grep "log-level=\"debug\"" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_2_3"
else
  pass "$check_2_3"
fi

# 2.4
check_2_4="2.4  - Allow Docker to make changes to iptables"
pgrep -lf docker | grep "iptables=false" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_2_4"
else
  pass "$check_2_4"
fi

# 2.5
check_2_5="2.5  - Do not use insecure registries"
pgrep -lf docker | grep "insecure-registry" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_2_5"
else
  pass "$check_2_5"
fi

# 2.6
check_2_6="2.6  - Setup a local registry mirror"
pgrep -lf docker | grep "registry-mirror" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  pass "$check_2_6"
else
  info "$check_2_6"
  info "     * No local registry currently configured"
fi

# 2.7
check_2_7="2.7  - Do not use the aufs storage driver"
docker info 2>/dev/null | grep -e "^Storage Driver:\s*aufs\s*$" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  warn "$check_2_7"
else
  pass "$check_2_7"
fi

# 2.8
check_2_8="2.8  - Do not bind Docker to another IP/Port or a Unix socket"
pgrep -lf docker | grep "\-H" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  info "$check_2_8"
  info "     * Docker daemon running with -H"
else
  pass "$check_2_8"
fi

# 2.9
check_2_9="2.9  - Configure TLS authentication for Docker daemon"
pgrep -lf docker | grep "\-H" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  pgrep -lf docker | grep "tlsverify" | grep "tlskey" >/dev/null 2>&1
  if [ $? -eq 0 ]; then
    pass "$check_2_9"
    info "     * Docker daemon currently listening on TCP"
  else
    warn "$check_2_9"
    warn "     * Docker daemon currently listening on TCP without --tlsverify"
  fi
else
  info "$check_2_9"
  info "     * Docker daemon not listening on TCP"
fi

# 2.10
check_2_10="2.10 - Set default ulimit as appropriate"
pgrep -lf docker | grep "default-ulimit" >/dev/null 2>&1
if [ $? -eq 0 ]; then
  pass "$check_2_10"
else
  info "$check_2_10"
  info "     * Default ulimit doesn't appear to be set"
fi
