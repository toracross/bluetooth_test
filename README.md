# Bluetooth Test

A simple test of the CoreBluetooth framework.

The CBCentralManager is scanning for all nearby devices, all found devices with a valid name will be appended to the tableview.

Tapping on a row will attempt to connect to that peripheral, upon a successful connection, a for loop will print all available services for that particular device.
