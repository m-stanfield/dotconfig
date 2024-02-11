#!/bin/bash

vari=$(pacmd list-sinks | grep "^\s*index:" | tr -d "\n" | awk "{print \$2}")
pacmd set-default-sink $vari
