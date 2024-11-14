//
//  ChooseSpot.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/31/24.
//

import SwiftUI

struct ChooseSpot: View {
    var spotSelection: ParkingSpot
    @State private var isButtonPressed = false
    @State private var successMessage: String?
    @State private var chosenSpot: (floor: Int, row: Int, column: Int)?
    
    @Environment(\.presentationMode) var presentationMode
    
    init(spotSelection: ParkingSpot) {
        self.spotSelection = spotSelection
        switch spotSelection {
        case .lot(let lot):
            _chosenSpot = State(initialValue: findFirstAvailableSpot(parkingSpots: lot.parkingSpots))
        case .building(let building):
            _chosenSpot = State(initialValue: findFirstAvailableSpot(parkingSpots: building.parkingSpots))
        }
    }
    
    var body: some View {
        VStack {
            switch spotSelection {
            case .lot(let lot):
                    Image(systemName: "car.fill")
                        .foregroundColor(.blue)
                        .padding()
                    
                    Text("Parking at \(lot.name)").font(.title3)
                        .padding()
                        .fontWeight(.bold)
                    
                Divider()
                
                if let spot = chosenSpot {
                    Text("Park at Spot: \(spot.row)\(spot.column)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Button("Accept") {
                        isButtonPressed = true
                        lot.parkingSpots[spot.floor][spot.row][spot.column] = true
                        lot.availableSpots -= 1
                        successMessage = "Successfully parked at Spot: \(spot.row)\(spot.column)"
                    }
                    .alert(isPresented: $isButtonPressed) {
                        Alert(
                            title: Text("Success"),
                            message: Text(successMessage ?? ""),
                            dismissButton: .default(Text("OK")) {
                                isButtonPressed = true
                                self.presentationMode.wrappedValue.dismiss()  // <-- Dismiss the view

                            }
                        )
                    }
                    .disabled(isButtonPressed)
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("No available spots")
                        .foregroundColor(.gray)
                }
                
            case .building(let building):
                    Image(systemName: "car.fill")
                        .foregroundColor(.blue)
                        .padding()
                    Text("Parking in \(building.name)").font(.title3)
                        .padding()
                        .fontWeight(.bold)
                
                    Divider()

                
                
                if let spot = chosenSpot {
                    Text("Park at Floor \(spot.floor + 1), Spot: \(spot.row)\(spot.column)")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                    
                    Button("Accept") {
                        isButtonPressed = true
                        building.parkingSpots[spot.floor][spot.row][spot.column] = true
                        building.availableSpots -= 1
                        successMessage = "Successfully parked at Floor \(spot.floor + 1), Spot: \(spot.row)\(spot.column)"
                    }
                    .alert(isPresented: $isButtonPressed) {
                        Alert(
                            title: Text("Success"),
                            message: Text(successMessage ?? ""),
                            dismissButton: .default(Text("OK")) {
                                isButtonPressed = true
                                self.presentationMode.wrappedValue.dismiss()  // <-- Dismiss the view

                            }
                        )
                    }
                    .disabled(isButtonPressed)
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("No available spots")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
    }
}

// Helper function for finding available spots
func findFirstAvailableSpot(parkingSpots: [[[Bool]]]) -> (floor: Int, row: Int, column: Int)? {
    for (floor, rows) in parkingSpots.enumerated() {
        for (row, columns) in rows.enumerated() {
            for (column, isOccupied) in columns.enumerated() {
                if !isOccupied {
                    return (floor, row, column)
                }
            }
        }
    }
    return nil
}

#Preview {
    ChooseSpot(spotSelection: ParkingSpot.building(buildings[2]))
}
