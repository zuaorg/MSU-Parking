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

class User: Identifiable {
    let id: String = UUID().uuidString
    var username: String
    var password: String
    var role: String  // Can be "admin" or "user"
    
    init(username: String, password: String, role: String) {
        self.username = username
        self.password = password
        self.role = role
    }
}

class Vehicle: Identifiable {
    let id: String = UUID().uuidString
    var userId: String  // User who parked the vehicle
    var licensePlate: String
    var lotId: String  // The Lot where the vehicle is parked
    var spot: (floor: Int, row: Int, column: Int)  // Coordinates of the parking spot in the lot
    
    init(userId: String, licensePlate: String, lotId: String, spot: (Int, Int, Int)) {
        self.userId = userId
        self.licensePlate = licensePlate
        self.lotId = lotId
        self.spot = spot
    }
}

class DataManager:ObservableObject {
    static let shared = DataManager()  // Singleton instance
    
    @Published var currentUser: User?
    
    @Published var lots: [Lot] = []
    @Published var buildings: [Building] = []
    @Published var entrances: [Entrance] = []
    @Published var users: [User] = []
    @Published var vehicles: [Vehicle] = []  // Track vehicles
    
    private init() {
        createEntrances()
        createEntrances2()
        createLots()
        createLots2()
        createBuildings()// Load data when the singleton is created
	createUsers()
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
    
    // Method to add Lot with validation (including name uniqueness)
    func addLot(name: String, coordinates: [Double], floors: Int, maxCapacity: Int, nearestEntranceId: String) -> Bool {
        // Check if the name already exists
        if lots.contains(where: { $0.name == name }) {
            return false // Name already exists, prevent adding
        }
        
        // Validate input data
        guard !name.isEmpty else {
            return false // Name must not be empty
        }
        guard coordinates.count == 2, coordinates[0] != 0, coordinates[1] != 0 else {
            return false // Coordinates should have two non-zero values
        }
        guard floors > 0 else {
            return false // Floors must be greater than 0
        }
        guard maxCapacity > 0 else {
            return false // Max Capacity must be greater than 0
        }

        let newLot = Lot(name: name, coordinates: coordinates, floors: floors, maxCapacity: maxCapacity, nearestEntranceId: nearestEntranceId)
        lots.append(newLot)
        return true
    }

    // Method to add Building with validation (including name uniqueness)
    func addBuilding(name: String, coordinates: [Double], floors: Int, maxCapacity: Int, nearestEntranceId: String) -> Bool {
        // Check if the name already exists
        if buildings.contains(where: { $0.name == name }) {
            return false // Name already exists, prevent adding
        }

        // Validate input data
        guard !name.isEmpty else {
            return false // Name must not be empty
        }
        guard coordinates.count == 2, coordinates[0] != 0, coordinates[1] != 0 else {
            return false // Coordinates should have two non-zero values
        }
        guard floors > 0 else {
            return false // Floors must be greater than 0
        }
        guard maxCapacity > 0 else {
            return false // Max Capacity must be greater than 0
        }

        let newBuilding = Building(name: name, coordinates: coordinates, floors: floors, maxCapacity: maxCapacity, nearestEntranceId: nearestEntranceId)
        buildings.append(newBuilding)
        return true
    }

    // Method to update Lot with validation (including name uniqueness)
    func updateLot(_ lot: Lot, name: String, coordinates: [Double], floors: Int, maxCapacity: Int) -> Bool {
        // Check if the name already exists (except for the current lot being updated)
        if lots.contains(where: { $0.name == name && $0.id != lot.id }) {
            return false // Name already exists, prevent updating
        }

        // Validate input data
        guard !name.isEmpty else {
            return false // Name must not be empty
        }
        guard coordinates.count == 2, coordinates[0] != 0, coordinates[1] != 0 else {
            return false // Coordinates should have two non-zero values
        }
        guard floors > 0 else {
            return false // Floors must be greater than 0
        }
        guard maxCapacity > 0 else {
            return false // Max Capacity must be greater than 0
        }

        if let index = lots.firstIndex(where: { $0.id == lot.id }) {
            lots[index].name = name
            lots[index].coordinates = coordinates
            lots[index].floors = floors
            lots[index].maxCapacity = maxCapacity
            return true
        }
        return false
    }

    // Method to update Building with validation (including name uniqueness)
    func updateBuilding(_ building: Building, name: String, coordinates: [Double], floors: Int, maxCapacity: Int) -> Bool {
        // Check if the name already exists (except for the current building being updated)
        if buildings.contains(where: { $0.name == name && $0.id != building.id }) {
            return false // Name already exists, prevent updating
        }

        // Validate input data
        guard !name.isEmpty else {
            return false // Name must not be empty
        }
        guard coordinates.count == 2, coordinates[0] != 0, coordinates[1] != 0 else {
            return false // Coordinates should have two non-zero values
        }
        guard floors > 0 else {
            return false // Floors must be greater than 0
        }
        guard maxCapacity > 0 else {
            return false // Max Capacity must be greater than 0
        }

        if let index = buildings.firstIndex(where: { $0.id == building.id }) {
            buildings[index].name = name
            buildings[index].coordinates = coordinates
            buildings[index].floors = floors
            buildings[index].maxCapacity = maxCapacity
            return true
        }
        return false
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
    
    // for users- admin or normal users
     //Function to create some dummy users
        private func createUsers() {
            let adminUser = User(username: "admin123", password: "admin123", role: "admin")
            let regularUser = User(username: "user123", password: "user123", role: "user")
            users.append(adminUser)
            users.append(regularUser)
        }

        // Register a new user
        func registerUser(username: String, password: String, role: String) -> Bool {
            // Check if username already exists
            if users.contains(where: { $0.username == username }) {
                return false  // Username already taken
            }

            let newUser = User(username: username, password: password, role: role)
            users.append(newUser)
            return true
        }

    // Method to authenticate a user
        func authenticateUser(username: String, password: String) -> User? {
            if let user = users.first(where: { $0.username == username && $0.password == password }) {
                currentUser = user  // Store the logged-in user
                return user
            }
            return nil
        }
    
        // Method to log out the user
        func logout() {
            currentUser = nil  // Clear the current user
        }
    
        func isLoggedIn() -> Bool {
                return currentUser != nil
        }
    
    // Park a vehicle in a lot
        func parkVehicle(userId: String, licensePlate: String, lotId: String, floor: Int, row: Int, column: Int) -> Bool {
            if let lot = lots.first(where: { $0.id == lotId }) {
                // Check if the spot is available
                if lot.parkingSpots[floor][row][column] == false {
                    lot.parkingSpots[floor][row][column] = true  // Mark the spot as occupied
                    let newVehicle = Vehicle(userId: userId, licensePlate: licensePlate, lotId: lotId, spot: (floor, row, column))
                    vehicles.append(newVehicle)
                    return true  // Vehicle successfully parked
                }
            }
            return false  // Spot is already occupied or lot is invalid
        }
        
        // Retrieve vehicles for a specific user
        func getVehiclesForUser(userId: String) -> [Vehicle] {
            return vehicles.filter { $0.userId == userId }
        }
        
        // Optionally, add a method to remove vehicle when the user leaves
        func removeVehicle(vehicleId: String) {
            if let index = vehicles.firstIndex(where: { $0.id == vehicleId }) {
                vehicles.remove(at: index)
            }
        }
}


