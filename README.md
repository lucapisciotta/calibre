# lucapisciotta/calibre
------------------------

[![CI](https://github.com/lucapisciotta/laboratory/actions/workflows/main.yml/badge.svg)](https://github.com/lucapisciotta/laboratory/actions/workflows/main.yml)
------------------------
[Calibre](https://github.com/kovidgoyal/calibre) server is an application to read, download and manage our eBooks.
In this image i put in a sample eBook that permit to see how the application works.
To manage the library, I advise to use calibre client on your machine, in this way you're able to add the tags, download the descriptions and fix the eBook code to show correctly on you eReader.

The image is based on the official ubuntu 21.04 and the offical calibre package provided by [Kovid Goyal](https://github.com/kovidgoyal/calibre)

### Why I have chosen to use this package and not calibre-web?
------------------------
I've an Amazon kindle and all other project that i tried have no compatibility with e-Ink display and its browser but, this has it.

### Supported architectures
------------------------
This image supports different architecture: `x86-64`, `arm64`, `arm32`.

### Application Setup
------------------------
WebUI can be found at `http://your-ip:8085`.

If you want to use a mobile and eReader compatibilty version, `http://your-ip:8085/mobile`.

Initially, you can try this image without an existing library because I've added a sample eBook. When you're ready and you've created your library you can simply pass it to `/books`.

### Usage
------------------------
Here are some example snippets to help you get started creating a container.

**docker-compose**
```
---
version: '3.8'
services:
    calibre:
        image: lucapisciotta/calibre
        container_name: calibre
        environment:
            - TZ=Europe/Rome
        volumes:
            - /path/to/calibre/library:/books
        ports:
            - 8085:8085
        restart: unless-stopped
```
**docker-cli**
```
docker run -d \
    --name=calibre \
    -e TZ=Europe/Rome \
    -p 8085:8085 \
    -v /path/to/calibre/library:/books \
    --restart unless-stopped \
    lucapisciotta/calibre
```
### Parameters
------------------------
Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate <external>:<internal> respectively. For example, -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080 outside the container.
| Parameter | Function |
| :---: | :---: |
|`-p 8085` | WebUI |
|`-e TZ=Europe/Rome` | Specify a timezone to use EG Europe/Rome. |
|`-v /books` | Where your preexisting calibre database is located. |

### Known problems
------------------------
Whene You start the container it show some errors about Bonjour service and zeroconf configuration but everything works as expected.
In any case, I'm working to fix also these problems.

### Sources
------------------------
Docker image repository: https://github.com/lucapisciotta/calibre

Calibre official repository: https://github.com/kovidgoyal/calibre