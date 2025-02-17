# docker-jellyfin

this repo includes a Dockerfile and a github action

the github action:
- clones jellyfin/jellyfin-ffmpeg 
- overlays the Dockerfile inside this repo
- builds jellyfin-ffmpeg from github on alpine 3.17
- installs jellyfin/jellyfin-web via alpine repositories
- publishes image to dockerhub

minimal poc
```
docker pull loeken/jellyfin:10.10.6
docker run -p 8096:8096 loeken/jellyfin
```
