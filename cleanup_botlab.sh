#!/bin/bash
pkill -9 -f slam
pkill -9 -f motion_controller
pkill -9 -f bin/timesync
pkill -9 -f rplidar_driver
pkill -9 -f motion_planning_server
pkill -9 -f omni_shim