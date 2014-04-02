#!/bin/sh
export MGC_WD=`pwd`

if [ ! -f modelsim.ini ]; then
  python scripts/init_modelsim.py
fi

