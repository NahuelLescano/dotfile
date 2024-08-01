#!/usr/bin/env bash

lxsession &
killall volumeicon && volumeicon &
picom &
nm-applet &
nitrogen --restore &
