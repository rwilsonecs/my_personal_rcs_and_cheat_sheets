#!/bin/bash

# Move the mouse slightly back and forth every 30 seconds
while true; do
    xdotool mousemove_relative -- 1 0
    sleep 1
    xdotool mousemove_relative -- -1 0
    sleep 30
done

