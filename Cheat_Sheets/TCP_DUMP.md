# 🐍 tcpdump Cheatsheet for Red Teamers

A quick reference for capturing and analyzing traffic during assessments.

---

## ⚡ Basic Syntax

```
sudo tcpdump -i <interface> [options] [filters]
```

---

## ✅ General Quick Captures

```
tcpdump -D
sudo tcpdump -i eth0
sudo tcpdump -i eth0 -w capture.pcap
tcpdump -r capture.pcap
```

---

## 🔎 Common Filters

```
tcpdump port 80
tcpdump src 10.0.0.5
tcpdump dst 10.0.0.5
tcpdump tcp
tcpdump udp
tcpdump arp
tcpdump icmp
tcpdump port 445 or port 139
```

---

## 🔥 Red Team Essentials

```
tcpdump -i eth0 -nnvvXSs 1514
tcpdump -i eth0 -nnvvXSs 1514 | grep -i POST
tcpdump -i eth0 port 53
tcpdump -i eth0 -nn -s0 -A port 21
tcpdump -i eth0 port 445
tcpdump -i eth0 port 88
tcpdump -i eth0 port 3389
tcpdump 'tcp[tcpflags] & tcp-syn != 0'
tcpdump 'tcp[tcpflags] & tcp-rst != 0'
tcpdump net 10.0.0.0/24
```

---

## 🕵️‍♂️ Stealth & Sniper Usage

```
tcpdump -c 10
tcpdump -n
tcpdump -nn
tcpdump -tttt
```

---

## 🗂️ Advanced Tactics

```
tcpdump host 10.0.0.5 and port 80
tcpdump 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
tcpdump greater 512
tcpdump -A -s 0 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'
```

---

## 🛠️ Pro Tips

Always set snap length (-s 0) when capturing credentials or exploit payloads to avoid truncated packets.

Combine with grep, awk, or tee for inline parsing:

```
tcpdump -i eth0 -nn -A | grep "password"
```

Use -G <seconds> -w 'file-%Y%m%d%H%M%S.pcap' for rotating capture files.

---

## 🎯 Final Example – The Nuclear Option

```
sudo tcpdump -i eth0 -nnvvXSs 0 -w everything.pcap
```

---


