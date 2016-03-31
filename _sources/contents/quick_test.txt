==============================
Quick Start 
==============================

The page explains how you can test the GiottoDataViewer with minimal steps.

Building Depot
---------------
#. Install BuildingDepot with demo database
#. Copy pythons scripts in demo_script folder to a server hosting BuildingDepot
#. Open giotto_setting.json
#. Write Building Depot's sever address in giotto_rest_api>server.
#. Run dummy_sensor.py ``$ python dummy_sensor.py`` This script continuously sends dummy data to sensors in Building Depot

GiottoDataViewer
-----------------
#. Build
	#. Create a local copy of this project
	#. Install CocoaPods_ if you haven't done it already
	#. Download Pod libraries at the project directory by executing pod install ``$ pod install``

	#. Open **GiottoDataViewer.xcworkspace** (not GiottoDataViewer.xcodeproj), build
	and install to an iPhone

#. Configure Parameters
	#. Open Settings tab in the iPhone app
	#. Tap Building Depot Server
	#. Configure Building Depot's address (e.g., ``https://buildingdepot.cmu.edu``)
	#. Tap Settings at the top left corner
	#. Tap Location Emulation
	#. Put ``Room1`` in the text field

#. Browse
	#. Open Devices tab
	#. You should see a list of devices (If it does not work, check the Log tab to see what is the problem)
	#. Tap one of the devices to see sensor readings

.. _CocoaPods: https://cocoapods.org 

