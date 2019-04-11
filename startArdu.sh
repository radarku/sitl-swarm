#!/bin/bash

numCopters=$1
initialAgentLat=$2
initialAgentLon=$3
initialAgentAlt=$4
initialAgentHeading=$5
incrementStepLat=$6
incrementStepLon=$7
MODEL=$8
SPEEDUP=$9

incrementStepAlt=0
incrementStepHdg=0

echo "Number of Copters: $numCopters"

# Start ArduPilots
LAT=${initialAgentLat}
LON=${initialAgentLon}
ALT=${initialAgentAlt}
HDG=${initialAgentHeading}

echo "Initial Position: $LAT,$LON,$ALT,$HDG"
echo "Increment Lat: $incrementStepLat"
echo "Increment Lon: $incrementStepLon"
echo "Model: $MODEL"
echo "SPEEDUP: $SPEEDUP"

arduPilotInstance=0

if [ $numCopters != 0 ]; then
	for i in $(seq 0 $(($numCopters-1))); do

           VEHICLE=arducopter
           INSTANCE=$arduPilotInstance

           simCommand="/ardupilot/build/sitl/bin/${VEHICLE} \
              -S \
              -I${INSTANCE} \
              --home ${LAT},${LON},${ALT},${DIR} \
              -w \
              --model ${MODEL} \
              --speedup ${SPEEDUP} \
              --defaults /ardupilot/Tools/autotest/default_params/copter.parm"

           echo "Starting Sim with command '$simCommand'"
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

# wait for all pids
for pid in ${pids[*]}; do
    wait $pid
done
