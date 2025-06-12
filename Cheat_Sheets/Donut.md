# Donut Cheat Sheet (In-Memory .NET Payloads for Red Teamers)

[Donut](https://github.com/TheWover/donut) is a payload generation tool that converts .NET assemblies into position-independent shellcode, enabling **in-memory execution** with no disk artifacts.

---

## 💾 Installation

```bash
git clone https://github.com/TheWover/donut.git
cd donut
mkdir build && cd build
cmake ..
make
```

---

## 🧠 Basic Usage

```bash
./donut ../payload/MyPayload.dll
```

- Generates shellcode: `loader.bin`
- Can be injected into memory via C, C#, PowerShell, etc.

---

## ⚙️ Common Options

| Option        | Description                         |
|---------------|-------------------------------------|
| `-f`          | Output format (default: BIN)        |
| `-a`          | Architecture (1=x86, 2=amd64, 3=any) |
| `-o`          | Output filename                     |
| `-b`          | Bypass AMSI/WLDP (1=enabled)        |
| `-x`          | Entry point in assembly             |
| `-c`          | Arguments to pass to entry method   |

---

## 🔧 Example: Cobalt Strike Compatible Shellcode

```bash
./donut -f 1 -a 2 -o shellcode.bin MyTool.dll
```

Use in CS:
```
beacon> inject shellcode.bin
```

---

## 🔐 AMSI/WLDP Bypass

Donut supports optional AMSI and WLDP bypassing:

```bash
./donut -b 1 MyPayload.dll
```

---

## 🧪 Pass Arguments to Assembly

```bash
./donut -c "username=admin password=supersecret" MyPayload.dll
```

---

## 📦 Output Formats

| Format | Description     |
|--------|-----------------|
| 1      | Binary (raw)    |
| 2      | Base64          |
| 3      | C               |
| 4      | Ruby            |
| 5      | Python          |
| 6      | PowerShell      |
| 7      | C#              |
| 8      | Hexadecimal     |

Example:
```bash
./donut -f 6 MyPayload.dll
```

---

## 🛠 Tool Wrappers

- **Inject with Rubeus**, `sharpinject`, or custom C loader
- Can be embedded in shellcode runners
- Excellent for **OPSEC-safe in-memory execution**

---

## 🧯 Tips

- Avoid hardcoded strings in your .NET payload — encrypt them
- Always compile .NET in **Release x64**, no debug info
- Pair with **Cobalt Strike**, **BOFs**, or **Sliver**
- Use Donut to deliver **C2 loaders**, **enumeration tools**, or **internal implants**

---


