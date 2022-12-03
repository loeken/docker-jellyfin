# docker-jellyfin

this repo includes a Dockerfile and a github action

the github action:
- clones jellyfin/jellyfin-ffmpeg 
- overlays the Dockerfile inside this repo
- builds jellyfin-ffmpeg based on alpine 3.17
- installs jellyfin/jellyfin-web via alpine repositories
