# Native plugin - native_printer

This plugin is used to connect the app with the native code to connect to the printer.

## Plugin Features:
This plugin contains multiple call methods -
1. discoverBluetoothPrinter - To discover the available bluetooth printers.
2. printToBluetoothPrinter - To connect and print the data to the bluetooth printer.
3. discoverWifiPrinters - To discover the available wifi/IPP printers.
4. printToWifiPrinter - To connect and print the data to the wifi/IPP printer.

## Android code -
1. NativePrinterPlugin - Plugin launch class where the method channel are handled.
2. BluetoothPrinterImpl/IBluetoothPrinter - Class to handle the bluetooth printer connection and print the data, it is been used to abstract and separate the code.
3. WifiIppPrinterImpl/WifiPrinterImpl/IWifiPrinter - Class to handle the wifi/IPP printer connection and print the data, it is been used to abstract and separate the code.

## Libraries used in the plugin -
1. Coroutines - For handling the async calls.
2. e.gmuth:ipp-client - For handling the IPP printer connection and print the data.

## iOS code -
1. NativePrinterPlugin - Plugin launch class where the method channel are handled.
2. BluetoothManager - Class to handle the bluetooth printer connection and print the data.
3. WiFiPrinterManager - Class to handle the wifi/IPP printer connection and print the data.

