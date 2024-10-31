//
//  data.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/22/24.
//

import Foundation

class Entrance: Identifiable {
    let id: String = UUID().uuidString
    
    var name: String = ""
    var coordinates: [Double] = []
    
    init (name: String, coordinates: [Double]) {
        self.name = name
        self.coordinates = coordinates
    }
}

class Lot: Identifiable {
    let id: String = UUID().uuidString
    
    var name: String = ""
    var coordinates: [Double] = []
    var floors: Int = 0
    var maxCapacity: Int = 0
    var availableSpots: Int = 0
    var nearestEntranceId: String?
    var parkingSpots: [[[Bool]]]
    
    init (name: String,coordinates: [Double], floors: Int, maxCapacity: Int, nearestEntranceId: String) {
        self.name = name
        self.coordinates = coordinates
        self.floors = floors
        self.maxCapacity = maxCapacity
        self.availableSpots = maxCapacity
        self.nearestEntranceId = nearestEntranceId
        self.parkingSpots = Array(
            repeating: Array(
                repeating: Array(repeating: false, count: 5),
                count: 5
            ),
            count: 3
        )
    }
}

class Building: Identifiable {
    let id: String = UUID().uuidString
    
    var name: String = ""
    var coordinates: [Double] = []
    var floors: Int = 0
    var maxCapacity: Int = 0
    var availableSpots: Int = 0
    var nearestEntranceId: String
    var parkingSpots: [[[Bool]]]
    
    init (name: String, coordinates: [Double], floors: Int, maxCapacity: Int, nearestEntranceId: String) {
        self.name = name
        self.coordinates = coordinates
        self.floors = floors
        self.maxCapacity = maxCapacity
        self.availableSpots = maxCapacity
        self.nearestEntranceId = nearestEntranceId
        self.parkingSpots = Array(
            repeating: Array(
                repeating: Array(repeating: false, count: 5),
                count: 5
            ),
            count: 3
        )
    }
}


class DataManager {
    static let shared = DataManager()  // Singleton instance
    
    var lots: [Lot] = []
    var buildings: [Building] = []
    var entrances: [Entrance] = []
    
    private init() {
        createEntrances()
        createLots()
        createLots2()
        createBuildings()// Load data when the singleton is created
    }
    
    private func createEntrances() {
        for number in 0...5 {
            let newEnt = Entrance(name: "Entrance-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)])
            entrances.append(newEnt)
        }
    }
    
    private func createLots() {
        for number in 0...5 {
            let newLot = Lot(name: "lot-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)], floors: 1, maxCapacity: 100 + number, nearestEntranceId: entrances[entrances.count - number - 1].id)
            lots.append(newLot)
        }
    }
    
    private func createLots2() {
        for number in 6...11 {
            let newLot = Lot(name: "lot-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)], floors: 1, maxCapacity: 100 + number, nearestEntranceId: entrances[number - 6].id)
            lots.append(newLot)
        }
    }

    private func createBuildings() {
        for number in 0...3 {
            let newBuild = Building(name: "building-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)], floors: 3, maxCapacity: 100 + number, nearestEntranceId: entrances[number].id)
            buildings.append(newBuild)
        }
    }
    }

