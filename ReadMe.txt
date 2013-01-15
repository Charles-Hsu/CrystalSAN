
### CrystalSAN ###

===========================================================================
DESCRIPTION:

CrystalSAN Project for Loxoll.

===========================================================================
BUILD REQUIREMENTS:

iOS 6.0 SDK

===========================================================================
RUNTIME REQUIREMENTS:

iPad OS 6.0 or later

===========================================================================
PACKAGING LIST:

AppDelegate.h/m
The application delegate class, responsible for application events and for bringing up the user interface.
Define total item number, and mapping button image type.

MainStoryboard.storyboard
UI graph interface

MainViewController.h/m
Root view controller (main page).
View controller transition is defined in storybpard.
Transition init code is in prepareForSegue:sender.

//ALCoverFlowViewController.h/m
//Implement circle and time machine effect pages.

//ALTopSitesViewController.h/m
//Implement Top sites effect page

iCarousel.m.m
effect view's base class.
check https://github.com/nicklockwood/iCarousel for detail document.

Resource
	BTN-on-xxx.png : Button image files from itch.
	bg@2x.png: background image from itch.
	Defaultxxx.png : launch images.
	AppIconxx.png : Icon images.


===========================================================================
CHANGES FROM PREVIOUS VERSIONS:

Version 1.0
	created and release to CrystalSAN project for demostaring to the Management of KBS.
