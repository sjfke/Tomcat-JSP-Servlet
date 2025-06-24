# Installing Docker Desktop

The project uses `Docker` and `Docker Compose` configuration files.

* [Install Docker Desktop on Mac](https://docs.docker.com/desktop/install/mac-install/)
* [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/)
* [Install Docker Desktop on Linux](https://docs.docker.com/desktop/install/linux-install/)

## Windows Platform Setup

Follow the instructions in [Install Docker Desktop on Windows](https://docs.docker.com/desktop/install/windows-install/).

Author uses ``WSL`` which does not require ``Hyper-V`` which is only available on a ``Windows Pro`` installation.

## General Docker and Docker Compose Notes

### Typical command usage

```console
# Once compose.yaml is created, see references (2, 3)
PS C:\Users\sjfke> docker compose build
PS C:\Users\sjfke> docker compose up -d 
PS C:\Users\sjfke> docker compose down

# Either of the following is more compact
PS C:\Users\sjfke> docker compose down --rmi local; docker compose build; docker compose up -d
PS C:\Users\sjfke> docker compose down --rmi local; docker compose up -d --build
```

1. [Docker: Reference documentation](https://docs.docker.com/reference/)
2. [Docker: Overview of Docker Compose](https://docs.docker.com/compose/)
3. [Docker: Compose specification](https://docs.docker.com/compose/compose-file)

## Docker Image Maintenance

```console
PS C:\Users\sjfke> docker image prune    # clean up dangling images
PS C:\Users\sjfke> docker system prune 
PS C:\Users\sjfke> docker rmi $(docker images -f 'dangling=true' -q) # bash only, images with no tags
```

## Docker Compose Networking

Unless explicitly configured otherwise `docker compose` will choose a subnet from the [RFC-1918 IP Space](https://www.ietf.org/rfc/rfc1918.txt), 
that is ``172.16/12``, ``192.168/16`` or ``10.0/8.``

```console
PS C:\Users\sjfke> docker network ls              # list docker networks by name
PS C:\Users\sjfke> docker inspect <network-name>  # details of network.
```

A good introduction [Docker-compose bridge network subnet](https://bobcares.com/blog/docker-compose-bridge-network-subnet/).

[One compose file solution](https://stackoverflow.com/questions/53949616/networks-created-by-docker-compose-do-not-respect-dockers-subnet-settings), be careful about IP range clashes.

```yaml
networks:
  default:
    driver: bridge
    ipam:
      driver: default
      config:
      - subnet:  10.103.0.1/16
```

## Docker Reference Documentation

* [Docker Reference documentation](https://docs.docker.com/reference/);
* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/);
* [Docker Compose file build reference](https://docs.docker.com/compose/compose-file/build/)
* [Docker SDK for Python](https://docker-py.readthedocs.io/en/stable/)
