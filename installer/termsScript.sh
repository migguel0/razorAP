#!/bin/bash

pwd=$(pwd)

sudo x-terminal-emulator -e $pwd/razorAP.sh &
sudo x-terminal-emulator -e $pwd/cracker.sh &
$(clear)
