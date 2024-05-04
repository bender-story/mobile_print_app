import CoreBluetooth
import Flutter

class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    private var centralManager: CBCentralManager?
    private var peripherals = [CBPeripheral]()
    private var result: FlutterResult?
    private var connectedPeripheral: CBPeripheral?
    private var characteristic: CBCharacteristic?
    private var dataToSend: Data?  // Data to send once connected

    func discoverDevices(result: @escaping FlutterResult) {
        self.result = result
        peripherals.removeAll()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        } else {
            result?(FlutterError(code: "BLUETOOTH_DISABLED", message: "Bluetooth is disabled", details: nil))
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
        }
    }

    func connectToPrinter(address: String, data: Data, result: @escaping FlutterResult) {
        guard let peripheral = peripherals.first(where: { $0.identifier.uuidString == address }) else {
            result(FlutterError(code: "DEVICE_NOT_FOUND", message: "Device not found", details: nil))
            return
        }
        self.result = result
        self.dataToSend = data
        centralManager?.connect(peripheral, options: nil)
        connectedPeripheral = peripheral
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) {
                self.characteristic = characteristic
                if let data = dataToSend {
                    writeValue(data: data)
                }
                break
            }
        }
    }

    func writeValue(data: Data) {
        guard let connectedPeripheral = connectedPeripheral, let characteristic = characteristic else {
            result?(FlutterError(code: "NO_CONNECTION", message: "No connected device", details: nil))
            return
        }
        connectedPeripheral.writeValue(data, for: characteristic, type: .withResponse)
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            result?(FlutterError(code: "WRITE_FAILED", message: "Failed to write data: \(error.localizedDescription)", details: nil))
        } else {
            result?("Success")
        }
    }
}
