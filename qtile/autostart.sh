#!/usr/bin/env bash

lxsession &
killall volumeicon && volumeicon &
nm-applet &
nitrogen --restore &
