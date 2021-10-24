#!/bin/bash
clear
fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
 tput civis
echo -ne "\033[1;33m["
while true; do
   for((i=0; i<18; i++)); do
   echo -ne "\033[1;31m#"
   sleep 0.1s
   done
   [[ -e $HOME/fim ]] && rm $HOME/fim && break
   echo -e "\033[1;33m]"
   sleep 1s
   tput cuu1
   tput dl1
   echo -ne "\033[1;33m["
done
echo -e "\033[1;33m]\033[1;37m -\033[1;32m OK !\033[1;37m"
tput cnorm
}

fun_udp1 () {
    [[ -e "/bin/badvpn-udpgw" ]] && {
    clear
    echo -e "\033[1;32mINICIANDO O BADVPN... \033[0m\n"
    fun_udpon () {
        tar xf badvpn-1.999.128.tar.bz2
cd badvpn-1.999.128/
cmake ~/badvpn-1.999.128 -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make install
echo "paleistas BadVPN portu 7300"
badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &
rm /root/badupd
echo "Badupd sekmingai irasytas!!"
echo "Buk_laisvas HS_pro 2019"
		}
        sleep 1
    }
    fun_bar 'fun_udpon'
    echo -e "\n  \033[1;32mBADVPN ATIVO !\033[0m"
    sleep 3
    menu
    } || {
        clear
        echo -e "\033[1;32mINSTALANDO O BADVPN !\033[0m\n"
	    inst_udp () {
	        cd $HOME
			apt-get update && apt-get upgrade && wget https://raw.githubusercontent.com/buklaisvas/Badvpn/master/badupd && bash badupd
	   }
	   fun_bar 'inst_udp'
	   echo -e "\n\033[1;32mINICIANDO O BADVPN... \033[0m\n"
       fun_udpon2 () {
           tar xf badvpn-1.999.128.tar.bz2
cd badvpn-1.999.128/
cmake ~/badvpn-1.999.128 -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_UDPGW=1
make install
echo "paleistas BadVPN portu 7300"
badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &
rm /root/badupd
echo "Badupd sekmingai irasytas!!"
echo "Buk_laisvas HS_pro 2019"
		   }
           sleep 1
       }
       fun_bar 'fun_udpon2'
       echo -e "\n\033[1;32mBADVPN ATIVO !\033[0m"
       sleep 3
       menu
    }
} 

fun_udp2 () {
    clear
    echo -e "\n\033[1;32mPARANDO O BADVPN...\033[0m\n"
    fun_stopbad () {
        sleep 1
        screen -X -S "udpvpn" kill
        screen -wipe 1>/dev/null 2>/dev/null
        [[ $(grep -wc "udpvpn" /etc/autostart) != '0' ]] && {
		    sed -i '/udpvpn/d' /etc/autostart
		}
        sleep 1
    }
    fun_bar 'fun_stopbad'
    echo -e "\n  \033[1;31mBADVPN PARADO !\033[0m"
    sleep 3
    menu
}
[[ $(ps x | grep "udpvpn"|grep -v grep |wc -l) = '0' ]] &&  fun_udp1 || fun_udp2
