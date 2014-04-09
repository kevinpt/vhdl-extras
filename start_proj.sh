#!/bin/sh
export MGC_WD=`pwd`

# Create default modelsim.ini with altered library mapping
if [ ! -f modelsim.ini ]; then
  python scripts/init_modelsim.py
fi

# Create build directory and Modelsim libs if they don't exist
if [ ! -d build ]; then
  mkdir -p build/lib
  vlib build/lib/extras
  vlib build/lib/test
fi
