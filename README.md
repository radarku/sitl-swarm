Multi-Agent ArduPilot Software-in-the-Loop Simulator Docker Container
=====================================================================

![sitl-swarm-logo](https://raw.githubusercontent.com/radarku/sitl-swarm/master/sitl-swarm-logo.png)

The purpose of this is to run /many/ ArduPilot SITL from within Docker.

DockerHub
---------

A pre-built Docker image is available on DockerHub at:

https://hub.docker.com/r/radarku/sitl-swarm

To download it, simply:

`docker pull radarku/sitl-swarm`
 
and to run it:

`docker run --rm -p 5760-5810:5760-5810 --env NUMCOPTERS=3 radarku/sitl-swarm`


Quick Start
-----------

If you'd rather build the docker image yourself:

`docker build --tag sitl-swarm .`

To run the image:

`docker run --rm -p 5760-5810:5760-5810 --env NUMCOPTERS=3 sitl-swarm`

This will start 3 ArduCopter SITL on host TCP ports 5760, 5770, and 5780; so to connect to it from the host, you could:

```
mavproxy.py --master=tcp:localhost:5760
mavproxy.py --master=tcp:localhost:5770
mavproxy.py --master=tcp:localhost:5780
```

Options
-------

The full list of options and their default values is:

```
INSTANCE          0
LAT               42.3898
LON               -71.1476
ALT               14
DIR               270
COPTERMODEL       +
SPEEDUP           1
NUMCOPTERS        0
INCREMENTSTEPLAT  0.01
INCREMENTSTEPLON  0.01
```

Vehicles and their corresponding models are listed below:

```
ArduCopter: octa-quad|tri|singlecopter|firefly|gazebo-
    iris|calibration|hexa|heli|+|heli-compound|dodeca-
    hexa|heli-dual|coaxcopter|X|quad|y6|IrisRos|octa
```
