# mobile_printer_app

A Flutter App for printing a receipt or custom text using Bluetooth or IP printers.

## App Features - UI: 
1. Homepage with two tabs.
2. First Tab: Contains a sample UI where users can enter the number of Shirts, Trousers, and Shoes a customer wants to purchase.
3. Once the user enters the number of items, the sub-total, GST, and total amount will be calculated and displayed.
4. Users can switch to the Second Tab to print custom text on the printer.
5. Clicking the Print button opens a dialog showing options to print via Bluetooth or IP printer.
6. Selecting Bluetooth printer initiates a scan for available printers.
7. After selecting a printer, the app will connect and attempt to print the data.
8. The print status is then returned to the app and displayed in a dialog.
9. Selecting IP printer allows users to enter the IP address and port number of the printer, or search for available printers.
10. Once a printer is selected, users can print the data.
11. Similar to Bluetooth, the print status is returned to the app and displayed in a dialog.

## App Structure - code :
1. Implements the Bloc pattern for state management.
2. Uses a custom native plugin for printer connectivity.
3. BluetoothPrinter: Manages connection with the Bluetooth printer plugin.
4. WifiPrinter: Manages connection with the Wi-Fi printer plugin.
5. ui/bluetooth: UI for Bluetooth printer settings.
6. ui/custom_print_page: UI for printing custom text.
7. ui/custom_ui: Contains widgets shared across the app.
8. ui/home_page: Home page UI with two tabs; serves as the launch screen.
9. ui/invoice: UI and state management for the invoice page.
10. ui/printers: UI and state management for the Wi-Fi printers page.
11. utils: Contains utility functions shared across the app.
12. test: Contains unit tests for utility functions.


# Native plugin - native_printer_bw

This plugin is used to connect the app with the native code to connect to the printer.

## Plugin Features:
This plugin contains multiple call methods -
1. **discoverBluetoothPrinter** - To discover the available bluetooth printers.
2. **printToBluetoothPrinter** - To connect and print the data to the bluetooth printer.
3. **discoverWifiPrinters** - To discover the available wifi/IPP printers.
4. **printToWifiPrinter** - To connect and print the data to the wifi/IPP printer.

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

# Screen shots 

## UI
<img src="https://github.com/bender-story/mobile_print_app/assets/10196013/184247d8-98cb-4e44-9b8f-612ec3f1ea0a" width="300" style="margin: 50px;">

<img src="https://github.com/bender-story/mobile_print_app/assets/10196013/f794939d-f23c-490e-adcd-a5d15ab91732" width="300" style="margin: 50px;">

<img src="https://github.com/bender-story/mobile_print_app/assets/10196013/2a5e3151-d6f5-4cda-b9e3-a2e7b1deae07" width="300" style="margin: 50px;">

## Bluetooth Printing

<img src="https://github.com/bender-story/mobile_print_app/assets/10196013/1329f702-5c24-4897-bb6e-59fbc3e09339" width="300" style="margin: 50px;">

<img src="https://github.com/bender-story/mobile_print_app/assets/10196013/db85b2b4-9eb1-404c-821b-21cfe3078c25" width="300" style="margin: 50px;">

## Wifi/IPP printing

<img src="https://github.com/bender-story/mobile_print_app/assets/10196013/4fc67a66-a3f3-42f3-8a04-e0f4f915ed20" width="300" style="margin: 50px;">

<img src="https://github.com/bender-story/mobile_print_app/assets/10196013/96c6148b-e513-4df6-a0b5-e3f9289b4271" width="300" style="margin: 50px;">

**I have successfully tested it with the Canon Printer; it can communicate with the printer and confirms that the connection is established. However, it appears that a specific driver might be necessary for actual printing, as the text did not print despite the positive response.**

<img src="https://github.com/bender-story/mobile_print_app/assets/10196013/7788f987-fcb9-49ee-9b2a-7a65ac5ad7db" width="300" style="margin: 50px;">
