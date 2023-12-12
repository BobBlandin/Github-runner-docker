# Git-hub-docker
Source : https://github.com/Pwd9000-ML/docker-github-runner-linux/tree/master
Docker compose file and build to use self-hosted runner


To start the runner
```
docker-compose -p local up -d --build
```

# Problems
## The docker deamon sock still not permitted
Set the permission of the docker.sock from the host machine to the container
```
chmod 666 /var/run/docker.sock
```