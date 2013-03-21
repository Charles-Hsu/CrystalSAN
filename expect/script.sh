#!/bin/sh

#  Script.sh
#  CrystalSAN
#
#  Created by Charles Hsu on 3/18/13.
#  Copyright (c) 2013 Charles Hsu. All rights reserved.

expect parse_engine_all.exp engine_227_all.xml /Library/WebServer/Documents/CrystalSANServer/server.db
expect parse_engine_all.exp engine_228_all.xml /Library/WebServer/Documents/CrystalSANServer/server.db
expect parse_engine_all.exp engine_229_all.xml /Library/WebServer/Documents/CrystalSANServer/server.db
expect parse_engine_all.exp engine_230_all.xml /Library/WebServer/Documents/CrystalSANServer/server.db
expect parse_engine_all.exp engine_231_all.xml /Library/WebServer/Documents/CrystalSANServer/server.db
expect parse_engine_all.exp engine_232_all.xml /Library/WebServer/Documents/CrystalSANServer/server.db
expect parse_engine_all.exp engine_233_all.xml /Library/WebServer/Documents/CrystalSANServer/server.db
expect parse_engine_all.exp engine_234_all.xml /Library/WebServer/Documents/CrystalSANServer/server.db
expect scan_ha_cluster.exp /Library/WebServer/Documents/CrystalSANServer/server.db
