sudo apt install linux-cloud-tools-common
sudo apt install linux-tools-generic -y
sudo apt install linux-cloud-tools-generic -y

hv_fcopy_daemon
hv_kvp_daemon
hv_set_ifconfig
hv_vss_daemon
hv_get_dns_info

sudo shutdown -r now
