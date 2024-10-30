//
//  data.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/22/24.
//

import Foundation

class entrance {
    let id: String = UUID().uuidString
    
    var name: String = ""
    var coordinates: [Double] = []
    
    init (name: String, coordinates: [Double]) {
        self.name = name
        self.coordinates = coordinates
    }
}

class lot {
    let id: String = UUID().uuidString
    
    var name: String = ""
    var coordinates: [Double] = []
    var floors: Int = 0
    var maxCapacity: Int = 0
    var availableSpots: Int = 0
    
    init (name: String,coordinates: [Double], floors: Int, maxCapacity: Int) {
        self.name = name
        self.coordinates = coordinates
        self.floors = floors
        self.maxCapacity = maxCapacity
        self.availableSpots = maxCapacity
    }
}

class building {
    let id: String = UUID().uuidString
    
    var name: String = ""
    var coordinates: [Double] = []
    var floors: Int = 0
    var maxCapacity: Int = 0
    var availableSpots: Int = 0
    
    init (name: String, coordinates: [Double], floors: Int, maxCapacity: Int) {
        self.name = name
        self.coordinates = coordinates
        self.floors = floors
        self.maxCapacity = maxCapacity
        self.availableSpots = maxCapacity
    }
}


class DataManager {
    static let shared = DataManager()  // Singleton instance
    
    var lots: [lot] = []
    var buildings: [building] = []
    var entrances: [entrance] = []
    
    private init() {
        createLots()
        createBuildings()
        createEntrances()// Load data when the singleton is created
    }
    
    private func createLots() {
        for number in 1...5 {
            let newLot = lot(name: "lot-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)], floors: 1, maxCapacity: 100 + number)
            lots.append(newLot)
        }
    }

    private func createBuildings() {
        for number in 1...5 {
            let newBuild = building(name: "building-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)], floors: 1 + number, maxCapacity: 100 + number)
            buildings.append(newBuild)
        }
    }

    
    private func createEntrances() {
        for number in 1...5 {
            let newEnt = entrance(name: "Entrance-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)])
            entrances.append(newEnt)
        }
    }
}

