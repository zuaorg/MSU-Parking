//
//  ContentView.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/22/24.
//

import SwiftUI

enum ParkingSelection {
    case lot(Lot)
    case building(Building)
}

struct ChooseLot: View {
    var lots: [Lot]
    var buildings: [Building]
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Lots")
                    .font(.title)
                    .padding()
                
                if !lots.isEmpty {
                    List(lots, id: \.id) { lot in
                        
                        if lot.availableSpots > 0 {
                            NavigationLink(destination: ChooseSpot(selection: .lot(lot))) {
                                Text("Lot: \(lot.name) - Availability: \(lot.availableSpots)")
                            }
                            
                        }
                    }
                }
                else {
                    Text("No Lots Found")
                }
                
                Divider()
                
                Text("Buildings")
                    .font(.title)
                    .padding()
                
                if !buildings.isEmpty{
                    List(buildings, id: \.id) { building in
                        if building.availableSpots > 0 {
                            NavigationLink(destination: ChooseSpot(selection: .building(building))) {
                                Text("Lot: \(building.name) - Availability: \(building.availableSpots)")
                            }
                        }
                    }
                }
                else{
                    Text("No Buildings Found")
                }
            }
            .onAppear {
                // Print lots and buildings when the view appears
                print("Passed Lots: \(lots.count)")
                print("Passed Buildings: \(buildings.count)")
            }
        }
    }
}

#Preview {
    ChooseLot(lots: lots, buildings: buildings)
}
