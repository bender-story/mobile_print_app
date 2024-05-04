import Flutter

class NativePrinterPlugin: NSObject, FlutterPlugin {
    private var bluetoothManager: BluetoothManager?
    private var wifiPrinterManager = WiFiPrinterManager()

    static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "native_printer", binaryMessenger: registrar.messenger())
        let instance = NativePrinterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    override init() {
        super.init()
        bluetoothManager = BluetoothManager()
    }

    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "discoverBluetoothPrinter":
            bluetoothManager?.discoverDevices(result: result)

        case "printToBluetoothPrinter":
            guard let args = call.arguments as? [String: Any],
                  let address = args["address"] as? String,
                  let data = args["data"] as? String,
                  let dataToSend = data.data(using: .utf8) else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Required parameters are missing or invalid", details: nil))
                return
            }
            bluetoothManager?.connectToPrinter(address: address, data: dataToSend, result: result)

        case "discoverWifiPrinters":
            if let args = call.arguments as? [String: Any], let networkBase = args["networkBase"] as? String {
                wifiPrinterManager.discoverPrinters(networkBase: networkBase, result: result)
            } else {
                result(FlutterError(code: "BAD_ARGS", message: "Network base not provided", details: nil))
            }

        case "printToWifiPrinter":
            if let args = call.arguments as? [String: Any],
               let ipAddress = args["ipAddress"] as? String,
               let data = args["data"] as? String {
                wifiPrinterManager.printToWifiPrinter(ipAddress: ipAddress, data: data, result: result)
            } else {
                result(FlutterError(code: "BAD_ARGS", message: "Missing arguments for printing", details: nil))
            }

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
