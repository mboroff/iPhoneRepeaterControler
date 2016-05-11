//
//  BTService.swift
//  rsuv3RepeaterController
//
//  Created by Marty on 2/3/16.
//  Copyright © 2016 Marty. All rights reserved.
//
//  The receiving data from Bluetooth was developed with much help from Jari Isohanni
//
//



import Foundation
import CoreBluetooth

/* Services & Characteristics UUIDs */
let BLEServiceUUID = CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")

// Define TXD characteristic
let TXDCharUUID = CBUUID(string: "6E400002-B5A3-F393-E0A9-E50E24DCCA9E")

// Define RXD characteristic
let RXDCharUUID = CBUUID(string: "6E400003-B5A3-F393-E0A9-E50E24DCCA9E")

// Define change notification status
let BLEServiceChangedStatusNotification = "kBLEServiceChangedStatusNotification"
let BLEReadDataNotification = "kBLEReadDataNotification"

class BTService: NSObject, CBPeripheralDelegate {
    var peripheral: CBPeripheral?
    var transmitCharacteristic: CBCharacteristic?
    var receiveCharacteristic: CBCharacteristic?
    
 
    init(initWithPeripheral peripheral: CBPeripheral)
    {
        super.init()
        
        self.peripheral = peripheral
        self.peripheral?.delegate = self
        self.peripheral = peripheral
        self.peripheral?.delegate = self
    }
    
    deinit {
        self.reset()
    }
    
    func startDiscoveringServices() {
        self.peripheral?.discoverServices([BLEServiceUUID])
    }
    
    func reset() {
        if peripheral != nil {
            peripheral = nil
        }
        
        // Deallocating therefore send notification
        self.sendBTServiceNotificationWithIsBluetoothConnected(false)
    }
    
    // Mark: - CBPeripheralDelegate
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        let uuidsForBTService: [CBUUID] = [TXDCharUUID, RXDCharUUID]
        
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if ((peripheral.services == nil) || (peripheral.services!.count == 0)) {
            // No Services
            return
        }
        
        for service in peripheral.services! {
            if service.UUID == BLEServiceUUID {
                peripheral.discoverCharacteristics(uuidsForBTService, forService: service)
            }
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if (peripheral != self.peripheral) {
            // Wrong Peripheral
            return
        }
        
        if (error != nil) {
            return
        }
        
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.UUID == RXDCharUUID {
                    self.transmitCharacteristic = (characteristic)
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            
                    // Send notification that Bluetooth is connected and all required characteristics are discovered
                    self.sendBTServiceNotificationWithIsBluetoothConnected(true)
                    }  //end if
                    if characteristic.UUID == TXDCharUUID {
                    self.transmitCharacteristic = (characteristic)
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            
                    // Send notification that Bluetooth is connected and all required characteristics are discovered
                    self.sendBTServiceNotificationWithIsBluetoothConnected(true)
                    } // end if
                } // end of for
            }  // end of if  let
    }
    

    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if(characteristic.UUID != RXDCharUUID){
            return
        }
            //    let resstr = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding)
        
        var userInfo = [String: AnyObject]()
        userInfo["data"] =  characteristic.value;
        
        NSNotificationCenter.defaultCenter().postNotificationName(BLEReadDataNotification, object: self, userInfo: userInfo)
    }
    
    
    func writeChars(charactersToSend: String) {
        // See if characteristic has been discovered before writing to it
        if let transmitCharacteristic = self.transmitCharacteristic {
            // Need a mutable var to pass to writeValue function
               let numberOfBytesToSend:Int = charactersToSend.characters.count
                let data = NSData(bytes: charactersToSend, length: numberOfBytesToSend)
                self.peripheral?.writeValue(data, forCharacteristic: transmitCharacteristic, type: CBCharacteristicWriteType.WithResponse)
        }
    }
    
    func sendBTServiceNotificationWithIsBluetoothConnected(isBluetoothConnected: Bool) {
        let connectionDetails = ["isConnected": isBluetoothConnected]
        NSNotificationCenter.defaultCenter().postNotificationName(BLEServiceChangedStatusNotification, object: self, userInfo: connectionDetails)
    }
    
}