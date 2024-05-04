import Foundation
import Network

class WiFiPrinterManager {
    private var result: FlutterResult?

    func discoverPrinters(networkBase: String, result: @escaping FlutterResult) {
        self.result = result
        // Assuming printers are on a specific port such as IPP's 631
        let port = NWEndpoint.Port(rawValue: 631)!
        var discoveredPrinters = [[String: String]]()

        // Creating a range of IPs to scan (simplified for example)
        for i in 1...254 {
            let host = "\(networkBase).\(i)"
            let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: port)
            let parameters = NWParameters()
            parameters.requiredInterfaceType = .wifi

            let connection = NWConnection(to: endpoint, using: parameters)
            connection.stateUpdateHandler = { state in
                switch state {
                case .ready:
                    print("\(host) has a printer")
                    discoveredPrinters.append(["name": "Printer at \(host)", "address": host])
                    connection.cancel() // Close connection after discovery
                default:
                    break
                }
            }
            connection.start(queue: .global())
        }

        // After scanning is done
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { // Wait for responses
            result(discoveredPrinters)
        }
    }

    func printToWifiPrinter(ipAddress: String, data: String, result: @escaping FlutterResult) {
        self.result = result
        let url = URL(string: "http://\(ipAddress):631/ipp/print")! // Adjust URL based on actual IPP setup
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    result(FlutterError(code: "PRINT_FAILED", message: "Failed to print: \(error.localizedDescription)", details: nil))
                }
                return
            }
            DispatchQueue.main.async {
                result("Print job sent successfully")
            }
        }.resume()
    }
}
