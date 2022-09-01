#!/bin/bash
help()
{
    echo "Launch Botlab code."
    echo
    echo "Usage:"
    echo "    -h            Print help and exit."
}

TIMESTAMP=$(date "+%y%m%d_%H%M%S")  # For log files.
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LOG_DIR="/home/pi/.logs"
MAP_FILE="$ROOT_DIR/maps/current.map"  # Default map file.
PARTICLE_COUNT=200

# Make the log directory, if it doesn't exist.
if [ ! -d $LOG_DIR ]; then
    mkdir $LOG_DIR
fi
echo "Logging to: $LOG_DIR"

echo "Cleaning up any running MBot code."
sudo $ROOT_DIR/cleanup_botlab.sh

echo "Launching timesync"
$ROOT_DIR/bin/timesync &> /dev/null &
echo "Launching Lidar driver"
$ROOT_DIR/bin/rplidar_driver &> /dev/null &
echo "Launching motion planning server"
$ROOT_DIR/bin/motion_planning_server &> /dev/null &
echo "Launching pico shim"
$ROOT_DIR/bin/omni_shim &> /dev/null &
echo "Launching motion controller"
$ROOT_DIR/bin/motion_controller &> /dev/null &
echo "Launching SLAM"
$ROOT_DIR/bin/slam --num-particles $PARTICLE_COUNT &> /dev/null &

# Create sim links to the log files.
# ln -sf $LOG_DIR/timesync_$TIMESTAMP.log $LOG_DIR/timesync_latest.log
# ln -sf $LOG_DIR/rplidar_driver_$TIMESTAMP.log $LOG_DIR/rplidar_driver_latest.log
# ln -sf $LOG_DIR/motion_controller_$TIMESTAMP.log $LOG_DIR/motion_controller_latest.log
# ln -sf $LOG_DIR/slam_$TIMESTAMP.log $LOG_DIR/slam_latest.log
# ln -sf $LOG_DIR/motion_planning_server_$TIMESTAMP.log $LOG_DIR/motion_planning_server_latest.log
# ln -sf $LOG_DIR/omni_shim_$TIMESTAMP.log $LOG_DIR/omni_shim_latest.log
