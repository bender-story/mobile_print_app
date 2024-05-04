# mobile_printer_app

Flutter App for printing a receipt or Custom text on a Bluetooth or IP printer.

App contains - UI- Features: 
1. Homepage with two tabs
2. First Tab contains a sample UI - where users can enter the number of Shirts, Trousers and Shoes that a customer want to buy.
3. Once user enters the number of items the sub-total, gst and total amount will be calculated and displayed.
4. User can click on second tab to print a custom text on the printer.
5. Once user clicks on print button then dialog is populated to show option to print in bluetooth or IP printer.
6. When user selects bluetooth printer then app will scan for available printers.
7. Once user clicks on the any of the printers the app will connect and try too print the data.
8. And the print status has been returned to app and populated to the user in a dialog.
9. If user selects IP printer then user can enter the IP address and port number of the printer and click on print button.
10. Or he can click on the search for available prints and select the printer to print the data.
11. And the print status has been returned to app and populated to the user in a dialog.

App Contains - code :
1. Used bloc pattern for state management.
2. Used a custom native plugin to connect to the printer.
3. BluetoothPrinter - Connects the app with the bluetooth printer plugin.
4. WifiPrinter - Connects the app with the wifi printer plugin.
5. ui/bluetooth - Contains the UI for bluetooth printer.
6. ui/custom_print_page - Contains the UI for custom text print.
7. ui/custom_ui - Contains the widgets that can be shared across the app.
8. ui/home_page - Contains the UI for the home page with two tabs and this is the launch screen.
9. ui/invoice - contains the UI for the invoice page and its state management code
10. ui/printers - contains the UI for the wifi printers page and its state management code
11. utils - contains the utility functions that can be shared across the app.
12. test - have some unit tests for the utility functions.

## Native plugin - native_printer

This plugin is used to connect the app with the native code to connect to the printer.

This plugin contains multiple call methods -
1. discoverBluetoothPrinter - To discover the available bluetooth printers.
2. printToBluetoothPrinter - To connect and print the data to the bluetooth printer.
3. discoverWifiPrinters - To discover the available wifi/IPP printers.
4. printToWifiPrinter - To connect and print the data to the wifi/IPP printer.

Android code -
1. NativePrinterPlugin - Plugin launch class where the method channel are handled.
2. BluetoothPrinterImpl/IBluetoothPrinter - Class to handle the bluetooth printer connection and print the data, it is been used to abstract and separate the code.
3. WifiIppPrinterImpl/WifiPrinterImpl/IWifiPrinter - Class to handle the wifi/IPP printer connection and print the data, it is been used to abstract and separate the code.

Libraries used in the plugin -
1. Coroutines - For handling the async calls.
2. e.gmuth:ipp-client - For handling the IPP printer connection and print the data.

iOS code -
1. NativePrinterPlugin - Plugin launch class where the method channel are handled.
2. BluetoothManager - Class to handle the bluetooth printer connection and print the data.
3. WiFiPrinterManager - Class to handle the wifi/IPP printer connection and print the data.

