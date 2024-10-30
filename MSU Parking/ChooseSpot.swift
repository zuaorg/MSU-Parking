//
//  ContentView.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/22/24.
//

import SwiftUI

struct ChooseSpot: View {
    var lots = DataManager.shared.lots  // Access the shared data
    var buildings = DataManager.shared.buildings

    var body: some View {
        VStack {
                    Text("Lots")
                        .font(.headline)
                    
            List(lots, id: \.id) { lot in
                
                if lot.availableSpots > 103 {
                    Text("Lot: \(lot.name) - Capacity: \(lot.maxCapacity)")
                }
            }

            
                    Text("Buildings")
                        .font(.headline)
                    
            List(buildings, id: \.id) { building in
                if building.availableSpots > 103 {
                    Text("Building: \(building.name) - Floors: \(building.floors)")
                }
            }
                }
                .padding()
    }
    }

#Preview {
    ChooseSpot()
}
