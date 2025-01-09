#!/bin/bash

while true; do
    # Randomly pick an image from the folder
    feh --bg-fill --randomize --recursive ~/Pictures
    # Wait for a specified interval (e.g., 10 seconds)
    sleep 30
done
