while true
do
badvpn-udpgw --listen-addr 127.0.0.1:7300 > /dev/null &
sleep 1
done
