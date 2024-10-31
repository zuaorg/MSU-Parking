//
//  ChooseSpot.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/31/24.
//

import SwiftUI

    struct ChooseSpot: View {
        var selection: ParkingSelection
        @State var successMessage: String?
        @State var isButtonPressed: Bool = false
        @State private var chosenSpot: (floor: Int, row: Int, column: Int)?
            
            // Initialize chosenSpot based on selection
            init(selection: ParkingSelection) {
                self.selection = selection
                if case .lot(let lot) = selection {
                    self._chosenSpot = State(initialValue: findFirstAvailableSpot(parkingSpots: lot.parkingSpots))
                } else if case .building(let building) = selection {
                    self._chosenSpot = State(initialValue: findFirstAvailableSpot(parkingSpots: building.parkingSpots))
                }
            }
        
        var body: some View {
            VStack {
                
                switch selection {
                case .lot(let lot):
                    Text("\(lot.name)").font(.title)
                    if let spot = chosenSpot {
                        Text("Park at Spot \(spot.row)\(spot.column)")
                        
                        Button("Accept") {
                            isButtonPressed = true
                            lot.parkingSpots[spot.floor][spot.row][spot.column] = true
                            lot.availableSpots -= 1
                            print(lot.availableSpots)
                        }
                        .buttonStyle(.borderedProminent)
                        .alert(isPresented: $isButtonPressed) {
                            Alert(
                                title: Text("Success"),
                                message: Text("You are parked at Spot \(spot.row)\(spot.column)"),
                                dismissButton: .default(Text("OK")) {
                                    isButtonPressed = true // disable the button after dismiss
                                }
                            )
                        }
                        .disabled(isButtonPressed) // Disable button if pressed
                    }
                    
                case .building(let building):
                    Text("\(building.name)").font(.title)
                    if let spot = chosenSpot {
                        Text("Park at Floor \(spot.floor + 1), Spot \(spot.row)\(spot.column)")
                        
                        Button("Accept") {
                            isButtonPressed = true
                            building.parkingSpots[spot.floor][spot.row][spot.column] = true
                            building.availableSpots -= 1
                            print(building.availableSpots)
                        }
                        .buttonStyle(.borderedProminent)
                        .alert(isPresented: $isButtonPressed) {
                            Alert(
                                title: Text("Success"),
                                message: Text("You are parked at Floor \(spot.floor + 1), Spot \(spot.row)\(spot.column)"),
                                dismissButton: .default(Text("OK")) {
                                    isButtonPressed = true // disable the button after dismiss
                                }
                            )
                        }
                        .disabled(isButtonPressed) // Disable button if pressed
                    }
                }
            }
            .padding()
        }
    }
    
    // Function to find the first available parking spot
    private func findFirstAvailableSpot(parkingSpots: [[[Bool]]]) -> (floor: Int, row: Int, column: Int)? {
            let numberOfFloors = parkingSpots.count
            let rowsPerFloor = parkingSpots.first?.count ?? 0
            let columnsPerRow = parkingSpots.first?.first?.count ?? 0
            
            for floor in 0..<numberOfFloors {
                for row in 0..<rowsPerFloor {
                    for column in 0..<columnsPerRow {
                        // Check if the spot is available (false means available)
                        if parkingSpots[floor][row][column] == false {
                            return (floor, row, column) // Return the first available spot
                        }
                    }
                }
            }
            return nil // No available spot found
        }
        

#Preview {
    ChooseSpot(selection: ParkingSelection.building(buildings[2]))
}
