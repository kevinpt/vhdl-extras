#!/bin/sh

./vhdl_gen | cat strings_maps_constants.head.vhdl - > strings_maps_constants.vhdl
