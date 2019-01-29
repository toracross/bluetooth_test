//
//  ViewController.swift
//  BLE-Test
//
//  Created by Wellison Pereira on 1/28/19.
//  Copyright © 2019 Wellison Pereira. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    //Variables
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
//    var cbUuid = CBUUID(string: "0x180D")
    var peripherals = [CBPeripheral]() {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBluetooth()
    }
    
    //Storyboard Actions

    //Functions
    private func setupBluetooth() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(peripherals[indexPath.row])
        centralManager.connect(peripherals[indexPath.row], options: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = peripherals[indexPath.row].name
        
        return cell
    }
}



extension ViewController: CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("Peripheral Updated: \(peripheral)")
    }
}

extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Device is powered on.")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("BL not available on this device.")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name, !name.isEmpty {
            peripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.peripheral = peripheral
        peripheral.delegate = self
        
        centralManager.stopScan()
        print("Connected to pheripheral:\n \(peripheral)")
        
        self.peripheral.discoverServices(nil)
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Peripheral was disconnected: \(peripheral.name ?? "")")
    }
}

extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            print(service)
        }
    }
}
