# SED Cheat Sheet for Hackers

## 🧱 Basics

```bash
sed 's/find/replace/' file.txt
```
Replace first occurrence of "find" with "replace" on each line

```bash
sed 's/find/replace/g' file.txt
```
Replace all occurrences globally on each line

```bash
sed -n '5p' file.txt
```
Print only line 5

```bash
sed -n '5,10p' file.txt
```
Print lines 5 through 10

```bash
sed -i 's/old/new/g' file.txt
```
Edit file in-place (replace "old" with "new")

---

## 🔧 Common Use Cases

```bash
sed '/pattern/d' file.txt
```
Delete lines matching a pattern

```bash
sed '1d' file.txt
```
Delete the first line (useful for skipping headers)

```bash
sed 's/[[:space:]]//g' file.txt
```
Remove all whitespace characters

```bash
sed -n '/start/,/end/p' file.txt
```
Print lines between matching "start" and "end" patterns

```bash
sed -n '/error/p' logs.txt
```
Print lines containing "error" — basic grep alternative

```bash
sed 's/.*password=//g' config.txt
```
Extract everything after "password="

---

## 🎯 Red Team & CTF Examples

```bash
sed 's/x27/'"'"'/g' payload.txt
```
Replace hex `x27` with single quote (useful for shellcode debugging)

```bash
cat creds.txt | sed 's/:.*//'
```
Extract usernames from colon-delimited creds (e.g., `user:pass`)

```bash
cat burp_log.txt | sed -n '/POST/,/^$/p'
```
Extract POST request bodies from Burp logs

```bash
sed 's/flag{[^}]*}/<REDACTED>/g' output.txt
```
Censor flags in shared output

```bash
strings binary | sed -n '/BEGIN CERTIFICATE/,/END CERTIFICATE/p'
```
Extract certs from binaries

---

## 🧠 Tips

- Use `-i` for in-place editing, but always back up first
- Use regex patterns with care — sed is greedy
- Wrap long sed commands in `"` if they contain variables
- Combine with `grep`, `cut`, `awk`, and `xargs` for complex pipelines
- Use `sed -E` for extended regex (no need to escape `+`, `?`, etc.)


