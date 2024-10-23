//
//  ContentView.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/22/24.
//

import SwiftUI

struct ContentView: View {
    var lots = DataManager.shared.lots  // Access the shared data
    var buildings = DataManager.shared.buildings

    var body: some View {
        VStack {
                    Text("Lots")
                        .font(.headline)
                    
                    List(lots, id: \.name) { lot in
                        Text("Lot: \(lot.name) - Capacity: \(lot.maxCapacity)")
                    }
                    
                    Text("Buildings")
                        .font(.headline)
                    
                    List(buildings, id: \.name) { building in
                        Text("Building: \(building.name) - Floors: \(building.floors)")
                    }
                }
                .padding()
    }
    }

#Preview {
    ContentView()
}
