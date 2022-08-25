#!/bin/bash
help()
{
    echo "Launch Botlab code."
    echo
    echo "Usage:"
    echo "    -h            Print help and exit."
    echo "    -s            Run Full slam."
    echo "    -l            Run in localization only mode. Use provided map for localization."
    echo "    -c            Do not run the motion controller."
    echo "    -m [MAP_FILE] The map file to save in full SLAM mode, or to load if in localization mode."
}

TIMESTAMP=$(date "+%y%m%d_%H%M%S")  # For log files.
ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
LOG_DIR="/home/$USER/.logs"

RUN_CONTROLLER=1
FULL_SLAM_MODE=0
LOCALIZATION_MODE=0

MAP_FILE="$ROOT_DIR/maps/current.map"  # Default map file.
PARTICLE_COUNT=200

while getopts ":hlscm:" option; do
    case $option in
        h)  # Help
            help
            exit;;
        l)  # Localization only
            LOCALIZATION_MODE=1;;
        s)  # Full slam mode.
            FULL_SLAM_MODE=1;;
        c)  # No controller
            RUN_CONTROLLER=0;;
        m)  # Map file.
            MAP_FILE=$OPTARG;;
        \?) # Invalid.
            echo "Invalid option provided."
            help
            exit;;
    esac
done

# Make the log directory, if it doesn't exist.
if [ ! -d $LOG_DIR ]; then
    mkdir $LOG_DIR
fi
echo "Logging to: $LOG_DIR"

echo "Cleaning up any running MBot code."
$ROOT_DIR/cleanup_botlab.sh

echo "Launching timesync, Lidar driver, and motion planning server."
source $ROOT_DIR/setenv.sh
$ROOT_DIR/bin/timesync &> $LOG_DIR/timesync_$TIMESTAMP.log &
$ROOT_DIR/bin/rplidar_driver &> $LOG_DIR/rplidar_driver_$TIMESTAMP.log &
$ROOT_DIR/bin/motion_planning_server &> $LOG_DIR/motion_planning_server_$TIMESTAMP.log &

if [[ RUN_CONTROLLER -eq 1 ]]; then
    echo "Launching motion controller."
    $ROOT_DIR/bin/motion_controller &> $LOG_DIR/motion_controller_$TIMESTAMP.log &
else
    echo "NOT launching motion controller."
fi

if [[ FULL_SLAM_MODE -eq 1 ]]; then
    echo "Launching SLAM in mapping mode (map will be saved in $MAP_FILE)."
    $ROOT_DIR/bin/slam --num-particles $PARTICLE_COUNT --map $MAP_FILE &> $LOG_DIR/slam_$TIMESTAMP.log &
else
    if [[ ! -f "$MAP_FILE" ]]; then
        echo "Map $MAP_FILE does not exist."
        exit
    fi
    echo "Launching SLAM in localization only mode with map $MAP_FILE"
    $ROOT_DIR/bin/slam --num-particles $PARTICLE_COUNT --map $MAP_FILE --localization-only --random-initial-pos &> $LOG_DIR/slam_$TIMESTAMP.log &
fi

# Create sim links to the log files.
ln -sf $LOG_DIR/timesync_$TIMESTAMP.log $LOG_DIR/timesync_latest.log
ln -sf $LOG_DIR/rplidar_driver_$TIMESTAMP.log $LOG_DIR/rplidar_driver_latest.log
ln -sf $LOG_DIR/motion_controller_$TIMESTAMP.log $LOG_DIR/motion_controller_latest.log
ln -sf $LOG_DIR/slam_$TIMESTAMP.log $LOG_DIR/slam_latest.log
ln -sf $LOG_DIR/motion_planning_server_$TIMESTAMP.log $LOG_DIR/motion_planning_server_latest.log
# ./bin/botgui