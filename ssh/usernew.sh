#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################
clear
cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
if [ "$cekray" = "XRAY" ]; then
domen=`cat /etc/xray/domain`
else
domen=`cat /etc/v2ray/domain`
fi

portsshws=`cat ~/log-install.txt | grep -w "SSH Websocket" | cut -d: -f2 | awk '{print $1}'`
wsssl=`cat /root/log-install.txt | grep -w "SSH SSL Websocket" | cut -d: -f2 | awk '{print $1}'`

clear
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m            SSH Account            \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p "Username : " Login
read -p "Password : " Pass
read -p "Max Login : " iplimit
read -p "Expired (Days): " masaaktif

IP=$(curl -sS ifconfig.me);
ossl=`cat /root/log-install.txt | grep -w "OpenVPN" | cut -f2 -d: | awk '{print $6}'`
opensh=`cat /root/log-install.txt | grep -w "OpenSSH" | cut -f2 -d: | awk '{print $1}'`
db=`cat /root/log-install.txt | grep -w "Dropbear" | cut -f2 -d: | awk '{print $1,$2}'`
ssl="$(cat ~/log-install.txt | grep -w "Stunnel4" | cut -d: -f2)"
sqd="$(cat ~/log-install.txt | grep -w "Squid" | cut -d: -f2)"
ovpn="$(netstat -nlpt | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
ovpn2="$(netstat -nlpu | grep -i openvpn | grep -i 0.0.0.0 | awk '{print $4}' | cut -d: -f2)"
domain=$(cat /etc/xray/domain)
OhpSSH=`cat /root/log-install.txt | grep -w "OHP SSH" | cut -d: -f2 | awk '{print $1}'`
OhpDB=`cat /root/log-install.txt | grep -w "OHP DBear" | cut -d: -f2 | awk '{print $1}'`
OhpOVPN=`cat /root/log-install.txt | grep -w "OHP OpenVPN" | cut -d: -f2 | awk '{print $1}'`
tgl=$(date -d "$masaaktif days" +"%d")
bln=$(date -d "$masaaktif days" +"%b")
thn=$(date -d "$masaaktif days" +"%Y")
expe="$tgl $bln, $thn"
tgl2=$(date +"%d")
bln2=$(date +"%b")
thn2=$(date +"%Y")
tnggl="$tgl2 $bln2, $thn2"

#sldomain=$(cat /etc/xray/dns)
#cdndomain=$(cat /root/awscdndomain)
#slkey=$(cat /etc/slowdns/server.pub)
clear
useradd -e `date -d "$masaaktif days" +"%Y-%m-%d"` -s /bin/false -M $Login
exp="$(chage -l $Login | grep "Account expires" | awk -F": " '{print $2}')"
echo -e "$Pass\n$Pass\n"|passwd $Login &> /dev/null

#limitip
if [[ $iplimit -gt 0 ]]; then
echo -e "$iplimit" > /etc/cobek/limit/ssh/ip/$Login
else
echo > /dev/null
fi
clear
echo -e "\033[0;34m◇━━━━━━━━━━━━━━━━━◇\033[0m" | tee -a /etc/log-create-user.log
echo -e "\E[0;41;36m  🇮🇩 SSH OVPN Account 🇮🇩  \E[0m" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m◇━━━━━━━━━━━━━━━━━◇\033[0m" | tee -a /etc/log-create-user.log
echo -e "Username     : $Login" | tee -a /etc/log-create-user.log
echo -e "Password     : $Pass" | tee -a /etc/log-create-user.log
echo -e "Max Login    : $iplimit" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m◇━━━━━━━━━━━━━━━━━◇\033[0m" | tee -a /etc/log-create-user.log
echo -e "IP           : $IP" | tee -a /etc/log-create-user.log
echo -e "Host         : ${domain}" | tee -a /etc/log-create-user.log
#echo -e "Host Dns    : $sldomain" | tee -a /etc/log-create-user.log
#echo -e "Pubkey      : $slkey" | tee -a /etc/log-create-user.log
echo -e "Port OpenSSH : 22" | tee -a /etc/log-create-user.log
echo -e "Port WS NTLS : 80, 8080, 8880, 2082" | tee -a /etc/log-create-user.log
echo -e "Port WS TLS  : 443" | tee -a /etc/log-create-user.log
echo -e "Port SSL/TLS : 443, 777" | tee -a /etc/log-create-user.log
echo -e "Port Ssh Udp : 1-65535" | tee -a /etc/log-create-user.log
echo -e "Port UDPGW   : 7100-7300" | tee -a /etc/log-create-user.log
echo -e "SSH-80       : ${domain}:80@$Login:$Pass" | tee -a /etc/log-create-user.log
echo -e "SSH-443      : ${domain}:443@$Login:$Pass" | tee -a /etc/log-create-user.log
echo -e "SSH-UDP      : ${domain}:1-65535@$Login:$Pass" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m◇━━━━━━━━━━━━━━━━━◇\033[0m" | tee -a /etc/log-create-user.log
echo -e "Aktif Selama : $masaaktif Hari" | tee -a /etc/log-create-user.log
echo -e "Dibuat Pada  : $tnggl" | tee -a /etc/log-create-user.log
echo -e "Berakhir Pada: $expe" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m◇━━━━━━━━━━━━━━━━━◇\033[0m" | tee -a /etc/log-create-user.log
echo -e "Payload Websocket NTLS :" | tee -a /etc/log-create-user.log
echo -e "GET / HTTP/1.1\n/<big><font color="Yellow">ISI NAMA MU <p style="text-align:center"[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m◇━━━━━━━━━━━━━━━━━◇\033[0m"
echo -e "" | tee -a /etc/log-create-user.log
echo -e "Payload Websocket TLS  :" | tee -a /etc/log-create-user.log
echo -e "GET https://[host]/ HTTP/1.1[crlf]Host: [host][crlf]Connection: Upgrade[crlf]User-Agent: [ua][crlf]Upgrade: websocket[crlf][crlf]" | tee -a /etc/log-create-user.log
echo -e "\033[0;34m◇━━━━━━━━━━━━━━━━━◇\033[0m" | tee -a /etc/log-create-user.log
echo "" | tee -a /etc/log-create-user.log
read -n 1 -s -r -p "SCRIPT BY BAYU & DANS"
echo -e "\033[0;34m◇━━━━━━━━━━━━━━━━━◇\033[0m"
menu
