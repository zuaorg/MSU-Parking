//
//  data.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/22/24.
//

import Foundation

enum Region: String, CaseIterable, Identifiable {
    case NORTH = "North"
    case SOUTH = "South"
    case EAST = "East"
    case WEST = "West"
    
    var id: String { self.rawValue }
}

class Entrance: Identifiable {
    let id: String = UUID().uuidString
    
    var name: String = ""
    var coordinates: [Double] = []
    var region: Region
    
    init (name: String, coordinates: [Double], region: Region) {
        self.name = name
        self.coordinates = coordinates
        self.region = region
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


class DataManager:ObservableObject {
    static let shared = DataManager()  // Singleton instance
    
    var lots: [Lot] = []
    var buildings: [Building] = []
    var entrances: [Entrance] = []
    
    private init() {
        createEntrances()
        createEntrances2()
        createLots()
        createLots2()
        createBuildings()// Load data when the singleton is created
    }
    
    private func createEntrances() {
        for number in 0...5 {
            let newEnt = Entrance(name: "North Hall-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)], region: Region.NORTH)
            entrances.append(newEnt)
        }
    }
    
    private func createEntrances2() {
        for number in 0...5 {
            let newEnt = Entrance(name: "South Hall-\(number)", coordinates: [123.0 + Double(number), 456.0 + Double(number)], region: Region.SOUTH)
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
    
    // Methods to add Lot and Building
        func addLot(name: String, coordinates: [Double], floors: Int, maxCapacity: Int, nearestEntranceId: String) {
            let newLot = Lot(name: name, coordinates: coordinates, floors: floors, maxCapacity: maxCapacity, nearestEntranceId: nearestEntranceId)
            lots.append(newLot)
        }
        
        func addBuilding(name: String, coordinates: [Double], floors: Int, maxCapacity: Int, nearestEntranceId: String) {
            let newBuilding = Building(name: name, coordinates: coordinates, floors: floors, maxCapacity: maxCapacity, nearestEntranceId: nearestEntranceId)
            buildings.append(newBuilding)
        }
        
        func updateLot(_ lot: Lot, name: String, coordinates: [Double], floors: Int, maxCapacity: Int) {
            if let index = lots.firstIndex(where: { $0.id == lot.id }) {
                lots[index].name = name
                lots[index].coordinates = coordinates
                lots[index].floors = floors
                lots[index].maxCapacity = maxCapacity
            }
        }

        func updateBuilding(_ building: Building, name: String, coordinates: [Double], floors: Int, maxCapacity: Int) {
            if let index = buildings.firstIndex(where: { $0.id == building.id }) {
                buildings[index].name = name
                buildings[index].coordinates = coordinates
                buildings[index].floors = floors
                buildings[index].maxCapacity = maxCapacity
            }
        }

        // Method to delete a Lot
        func deleteLot(_ lot: Lot) {
            if let index = lots.firstIndex(where: { $0.id == lot.id }) {
                lots.remove(at: index)
            }
        }

        // Method to delete a Building
        func deleteBuilding(_ building: Building) {
            if let index = buildings.firstIndex(where: { $0.id == building.id }) {
                buildings.remove(at: index)
            }
        }
}

