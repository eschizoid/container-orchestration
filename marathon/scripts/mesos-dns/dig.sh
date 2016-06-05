#!/usr/bin/env bash
if [ -n "$1" ]; then
    dig $1.marathon.mesos
else
    dig marathon.mesos
fi