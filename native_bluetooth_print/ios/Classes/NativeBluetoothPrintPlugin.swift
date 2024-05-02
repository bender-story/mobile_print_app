import Flutter
import UIKit
import CoreBluetooth

public class NativeBluetoothPrintPlugin: NSObject, FlutterPlugin, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var channel: FlutterMethodChannel!
    private var centralManager: CBCentralManager!
    private var discoveredPeripherals = [CBPeripheral]()
    private var connectedPeripheral: CBPeripheral?
    private var printCharacteristic: CBCharacteristic?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "native_bluetooth_print", binaryMessenger: registrar.messenger())
        let instance = NativeBluetoothPrintPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        instance.channel = channel
        instance.centralManager = CBCentralManager(delegate: instance, queue: nil)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "discoverDevices":
            discoverDevices(result: result)
        case "connect":
            guard let args = call.arguments as? [String: Any], let address = args["address"] as? String else {
                result(FlutterError(code: "NO_ADDRESS", message: "Bluetooth address is required", details: nil))
                return
            }
            connectToDevice(address: address, result: result)
        case "print":
            guard let args = call.arguments as? [String: Any], let data = args["data"] as? String else {
                result(FlutterError(code: "NO_DATA", message: "Print data is required", details: nil))
                return
            }
            sendData(data: data, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func discoverDevices(result: @escaping FlutterResult) {
        if centralManager.state != .poweredOn {
            result(FlutterError(code: "BLUETOOTH_DISABLED", message: "Bluetooth is disabled", details: nil))
            return
        }

        discoveredPeripherals.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            self.centralManager.stopScan()
            let devices = self.discoveredPeripherals.map { ["name": $0.name ?? "Unknown", "address": $0.identifier.uuidString] }
            result(devices)
        }
    }

    private func connectToDevice(address: String, result: @escaping FlutterResult) {
        guard let peripheral = discoveredPeripherals.first(where: { $0.identifier.uuidString == address }) else {
            result(FlutterError(code: "DEVICE_NOT_FOUND", message: "Device not found", details: nil))
            return
        }

        centralManager.connect(peripheral, options: nil)
        connectedPeripheral = peripheral
        peripheral.delegate = self
        result("Connecting...")
    }

    private func sendData(data: String, result: @escaping FlutterResult) {
        guard let connectedPeripheral = connectedPeripheral, let printCharacteristic = printCharacteristic else {
            result(FlutterError(code: "NOT_CONNECTED", message: "Not connected to a device", details: nil))
            return
        }

        if let dataToSend = data.data(using: .utf8) {
            connectedPeripheral.writeValue(dataToSend, for: printCharacteristic, type: .withResponse)
            result("Data sent successfully")
        } else {
            result(FlutterError(code: "DATA_FORMAT_ERROR", message: "Failed to encode data", details: nil))
        }
    }

    // CBCentralManagerDelegate methods
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("Bluetooth is not available.")
        }
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredPeripherals.append(peripheral)
        }
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // Discover services or characteristics as needed
        peripheral.discoverServices(nil)
    }

    // CBPeripheralDelegate methods
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            // Assuming you know the characteristic UUID
            peripheral.discoverCharacteristics([CBUUID(string: "00001101-0000-1000-8000-00805F9B34FB")], for: service)
        }
    }

    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) {
                printCharacteristic = characteristic
            }
        }
    }
}
