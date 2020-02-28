# Oskari docker image 

## 1. Build & run
```
docker build -t oskari_base ./oskari/
docker-compose -d up
```
## 2. Check
https://demo.oskari.joensuu.fi


# If Containers cant access internet

You can test if Docker dns setup is ok with:
```
docker run busybox nslookup google.com
```
If the "Address" has ip on it, its working. If this does not work test if connections work at all with:
```
docker run alpine ping 8.8.8.8
```
If this does not work the problem is deeper than just DNS

## Fix Host firewall settings to allow internet
```
firewall-cmd --permanent --zone=public --add-interface=docker0
firewall-cmd --direct --permanent --add-rule ipv4 filter INPUT 3 -i docker0 -j ACCEPT
firewall-cmd --reload
firewall-cmd --get-zone-of-interface=docker0
```
Last command should retunr "public"

Restart docker
```
systemctl restart docker
```