# docker-jellyfin

this repo includes a Dockerfile and a github action

the github action clones jellyfin/jellyfin-ffmpeg overlays the dockerfile inside this repo and builds jellyfin based on alpine 3.17

it builds jellyfin-ffmpeg from the git repo and installs jellyfin from the alpine repos.
