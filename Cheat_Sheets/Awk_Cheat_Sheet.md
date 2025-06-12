# AWK Cheat Sheet for Hackers

## 🧱 Basics

```bash
awk '{print}'
```
Print every line (default)

```bash
awk '{print $1}'
```
Print the first field

```bash
awk '{print $1, $3}'
```
Print the 1st and 3rd fields

```bash
awk -F ':' '{print $1}'
```
Use ":" as the field delimiter (common in passwd/shadow files)

---

## 🔧 Common Use Cases

```bash
awk -F: '{print $1}' /etc/passwd
```
List all usernames

```bash
awk '/Host:/ {print $2}' nmap.gnmap
```
Extract IPs from Nmap greppable output

```bash
awk -F" '/http/ {print $2}' burp_export.txt
```
Extract URLs from Burp logs

```bash
awk 'NF > 10' file.csv
```
Show lines with more than 10 fields (good for messy CSVs)

```bash
awk '{count[$1]++} END {for (ip in count) print ip, count[ip]}' ip_list.txt
```
Count unique IPs or values in a list

---

## 🎯 Red Team & CTF Examples

```bash
awk -F: '($2!/[*]/ && $2!/!/) {print $1 ":" $2}' /tmp/shadow
```
Show usernames and hashed passwords from shadow dump (ignores locked/disabled accounts)

```bash
awk '/login:/ {print $5 ":" $7}' hydra_output.txt
```
Parse Hydra output to get user:pass pairs

```bash
awk '{print $1}' creds.txt | sort | uniq
```
Deduplicate usernames or IPs

```bash
awk '{gsub(/x[0-9a-fA-F]{2}/, ".")} 1' payload.txt
```
Scrub hex-encoded shellcode for readability

```bash
awk '{if (length($0) > 100) print}' file.txt
```
Show lines longer than 100 characters (great for finding base64, JWTs, etc.)

```bash
awk '/flag{.*}/' output.txt
```
Hunt for flags in CTF output

---

## 🧠 Tips

- Use `-F` to change the delimiter (space is default)
- Use `NR` for line number, `NF` for field count
- Wrap logic in `BEGIN {}` and `END {}` for setup/final reporting
- Combine with `sort`, `uniq`, and `grep` for max power

