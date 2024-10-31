//
//  ChooseLot.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/29/24.
//

import SwiftUI

var entrances = DataManager.shared.entrances
var lots = DataManager.shared.lots  // Access the shared data
var buildings = DataManager.shared.buildings

struct ChooseEntrance: View {
    
    var body: some View {
            NavigationView {  // Added NavigationView to enable navigation
                VStack {
                    List(entrances, id: \.id) { entrance in
                        NavigationLink(destination: ChooseLot(lots: filteredLots(for: entrance), buildings: filteredBuildings(for: entrance))) {
                            Text(entrance.name)
                        }
                    }
                    .navigationTitle("Entrances") 
                }
            }
        }
    
    // Function to filter lots based on nearest entrance
        private func filteredLots(for entrance: Entrance) -> [Lot] {
            print("\(lots.filter { $0.nearestEntranceId == entrance.id }.count)")
            return lots.filter { $0.nearestEntranceId == entrance.id }
        }
        
        // Function to filter buildings based on nearest entrance
        private func filteredBuildings(for entrance: Entrance) -> [Building] {
            return buildings.filter { $0.nearestEntranceId == entrance.id }
        }
    
        }


#Preview {
    ChooseEntrance()
}


