#!/bin/bash
run_data() {
data=$(xray api statsquery --server=127.0.0.1:10005 | grep -C 2 $user | sed /"}"/d | sed /"{"/d | grep value | awk '{print $2}' | sed 's/,//g; s/"//g' | sort)
inb=$(echo "$data" | sed -n 1p)
outb=$(echo "$data" | sed -n 2p) 
vbaru=$(echo -e "$[ $inb + $outb ]")
}

run_file() {
cekfile=$(cat /etc/cobek/vmess/$user | wc -l)    
if [[ $cekfile -gt 0 ]]; then
echo > /dev/null
else
echo -e "0" > /etc/cobek/vmess/$user            
fi
cekfile1=$(cat /etc/cobek/cache/vmess-ws/$user | wc -l)
if [[ $cekfile1 -gt 0 ]]; then
echo > /dev/null
else
echo "0" > /etc/cobek/cache/vmess-ws/$user
fi
}    
    
run_sesi1() {
vbaru=$(echo -e "$[ $inb + $outb ]")        
vlama=$(cat /etc/cobek/cache/vmess-ws/$user)
vtotal=$(cat /etc/cobek/vmess/$user)        
if [[ $vbaru -gt $vlama ]]; then
vvar=$(echo -e "$[ $vbaru - $vlama ]" | sed "s/-//g")
echo -e "$[ $vvar + $vtotal ]" > /etc/cobek/vmess/$user
else
echo -e "$[ $vbaru + $vtotal ]" > /etc/cobek/vmess/$user
fi
}

run_inti() {
run_data
run_file   
vbaru=$(echo -e "$[ $inb + $outb ]")        
vlama=$(cat /etc/cobek/cache/vmess-ws/$user)          
if [ $vlama = $vbaru ]; then        
echo > /dev/null 
else
run_sesi1
fi                
echo "$vbaru" > /etc/cobek/cache/vmess-ws/$user
}

dataku=( `xray api statsquery --server=127.0.0.1:10005 | grep user | cut -d ">" -f 4 | sort | uniq`)
for user in "${dataku[@]}"
do
data1=$(echo "$data" | wc -c)
if [[ $data1 -gt 0 ]]; then
run_inti
else
echo > /dev/null
fi
sleep 0.1
done