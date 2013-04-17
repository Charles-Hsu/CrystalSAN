#!/bin/sh

#  update_script_database.sh
#  CrystalSAN
#
#  Created by Charles Hsu on 4/17/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.
cd "/Users/charles/Documents/Loxoll/CrystalSAN project/CrystalSAN/expect"
cp ./Scripts/scan_wwpn.exp /Users/charles/Desktop/Vicom-SMS-For-KBS/Scripts/scan_wwpn.exp
cd "/Users/charles/Desktop/Vicom-SMS-For-KBS"
expect Scripts/Vicom-script-daemon.exp &
#cd "/Users/charles/Documents/Loxoll/CrystalSAN project/CrystalSAN/expect"