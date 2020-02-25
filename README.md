# Oskari docker image 

## 1. hosts
Add `oskari.local` pointing localhost to your /etc/hosts file

## 2. Build & run
```
docker build -t oskari_base ./oskari/
docker-compose -d up
```
## 3. Check
http://oskari.local


Old instructions
```
docker build -t oskari_base .
docker run -p 8080:8080 -d oskari_base
```


