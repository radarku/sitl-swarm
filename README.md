Multi-Agent ArduPilot Software-in-the-Loop Simulator Docker Container
=====================================================================

The purpose of this is to run /many/ ArduPilot SITL from within Docker.

DockerHub
---------

Not in DockerHub yet...


Quick Start
-----------

If you'd rather build the docker image yourself:

`docker build --tag sitl-swarm .

To run the image:

`docker run -it --rm -p 5760-5800:5760-5800 --env NUMCOPTERS=5 sitl-swarm

This will start 5 ArduCopter SITL on host TCP port 5760, 5770, 5780, 5790, and 5800 so to connect to it from the host, you could:

`mavproxy.py --master=tcp:localhost:5760`
`mavproxy.py --master=tcp:localhost:5770`
`mavproxy.py --master=tcp:localhost:5780`
`mavproxy.py --master=tcp:localhost:5790`
`mavproxy.py --master=tcp:localhost:5800`

Options
-------

The full list of options and their default values is:

```
NUMCOPTER   3
INSTANCE    0
LAT         42.3898
LON         -71.1476
ALT         14
DIR         270
MODEL       +
SPEEDUP     1
VEHICLE     arducopter
```

Vehicles and their corresponding models are listed below:

```
arducopter: octa-quad|tri|singlecopter|firefly|gazebo-
    iris|calibration|hexa|heli|+|heli-compound|dodeca-
    hexa|heli-dual|coaxcopter|X|quad|y6|IrisRos|octa
ardurover: rover|gazebo-rover|rover-skid|calibration
ardusub: vectored
arduplane: gazebo-zephyr|CRRCSim|last_letter|plane-
    vtail|plane|quadplane-tilttri|quadplane|quadplane-
    tilttrivec|calibration|plane-elevon|plane-
    tailsitter|plane-dspoilers|quadplane-tri
    |quadplane-cl84|jsbsim
```
