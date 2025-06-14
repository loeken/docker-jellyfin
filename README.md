# docker-jellyfin

this repo includes a Dockerfile and a github action

the github action:
- clones jellyfin/jellyfin-ffmpeg 
- overlays the Dockerfile inside this repo
- builds jellyfin-ffmpeg from github on alpine
- installs jellyfin/jellyfin-web via alpine repositories
- publishes image to dockerhub
- updates itself via renovate
- supports playing x265

minimal poc
```
docker pull loeken/jellyfin:10.10.7
docker run -p 8096:8096 loeken/jellyfin
```
