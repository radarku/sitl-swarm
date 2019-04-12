#!/bin/bash

numCopters=$1
numRovers=$2
numSubs=$3
numPlanes=$4
initialAgentLat=$5
initialAgentLon=$6
initialAgentAlt=$7
initialAgentHeading=$8
incrementStepLat=$9
incrementStepLon=${10}
COPTERMODEL=${11}
ROVERMODEL=${12}
SUBMODEL=${13}
PLANEMODEL=${14}
SPEEDUP=${15}

incrementStepAlt=0
incrementStepHdg=0

echo "Number of Copters: $numCopters"
echo "Number of Rovers:  $numRovers"
echo "Number of Subs:    $numSubs"
echo "Number of Planes:  $numPlanes"

# Start ArduPilots
LAT=${initialAgentLat}
LON=${initialAgentLon}
ALT=${initialAgentAlt}
HDG=${initialAgentHeading}

echo "Initial Position: $LAT,$LON,$ALT,$HDG"
echo "Increment Lat: $incrementStepLat"
echo "Increment Lon: $incrementStepLon"
echo "CopterModel: $COPTERMODEL"
echo "RoverModel: $ROVERMODEL"
echo "SubModel: $SUBMODEL"
echo "PlaneModel: $PLANEMODEL"
echo "SPEEDUP: $SPEEDUP"

arduPilotInstance=0

if [ $numCopters != 0 ]; then
	for i in $(seq 0 $(($numCopters-1))); do

           VEHICLE=arducopter
           INSTANCE=$arduPilotInstance

           simCommand="/${VEHICLE} \
              -S \
              -I${INSTANCE} \
              --home ${LAT},${LON},${ALT},${DIR} \
              -w \
              --model ${COPTERMODEL} \
              --speedup ${SPEEDUP} \
              --defaults /copter/Tools/autotest/default_params/copter.parm"

           echo "Starting Sim ${VEHICLE} with command '$simCommand'"
           exec $simCommand &
           pids[${arduPilotInstance}]=$!

           #Make it so all the instances don't start at the same Lat/Lon
           LAT=$(echo "$LAT + $incrementStepLat" | bc)
           LON=$(echo "$LON + $incrementStepLon" | bc)
           ALT=$(echo "$ALT + $incrementStepAlt" | bc)
           HDG=$(echo "$HDG + $incrementStepHdg" | bc)

           # Increment arduPilotInstance
           let arduPilotInstance=$(($arduPilotInstance+1))

	done
fi

if [ $numRovers != 0 ]; then
	for i in $(seq 0 $(($numRovers-1))); do

           VEHICLE=ardurover
           INSTANCE=$arduPilotInstance

           simCommand="/${VEHICLE} \
              -S \
              -I${INSTANCE} \
              --home ${LAT},${LON},${ALT},${DIR} \
              -w \
              --model ${ROVERMODEL} \
              --speedup ${SPEEDUP} \
              --defaults /rover/Tools/autotest/default_params/rover-skid.parm"

           echo "Starting Sim ${VEHICLE} with command '$simCommand'"
           exec $simCommand &
           pids[${arduPilotInstance}]=$!

           #Make it so all the instances don't start at the same Lat/Lon
           LAT=$(echo "$LAT + $incrementStepLat" | bc)
           LON=$(echo "$LON + $incrementStepLon" | bc)
           ALT=$(echo "$ALT + $incrementStepAlt" | bc)
           HDG=$(echo "$HDG + $incrementStepHdg" | bc)

           # Increment arduPilotInstance
           let arduPilotInstance=$(($arduPilotInstance+1))

	done
fi

# No Subs or Planes yet...

# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
