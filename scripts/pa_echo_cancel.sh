#!/bin/env bash

pacmd load-module module-echo-cancel use_master_format=1 aec_method=webrtc aec_args="analog_gain_control=0\ digital_gain_control=1\ noise_suppression=1" source_name=echo_cancel_source sink_name=echo_cancel_sink
pacmd set-default-source echo_cancel_source
pacmd set-default-sink echo_cancel_sink
