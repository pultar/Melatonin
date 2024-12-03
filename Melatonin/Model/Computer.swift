//
//  Computer.swift
//  Melatonin
//

import SwiftData

@Model
class Computer {
    
    var name: String
    var macAddress: String
    var lowPowerMode: Bool
    
    init(name: String, macAddress: String, lowPowerMode: Bool) {
        self.name = name
        self.macAddress = macAddress
        self.lowPowerMode = lowPowerMode
    }
}
