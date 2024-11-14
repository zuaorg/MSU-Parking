//
//  ContentView.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/22/24.
//

import SwiftUI

enum ParkingSpot {
    case lot(Lot)
    case building(Building)
}

enum ParkingSelection: String, CaseIterable, Identifiable {
    case LOT = "Lots"
    case BUILDING = "Buildings"
    
    var id: String { self.rawValue }
}

struct ChooseLot: View {
     var lots: [Lot]
    var buildings: [Building]
    @State private var selectedItem: ParkingSelection = .LOT
    @State private var selectedSpot: ParkingSpot? = nil  // Made optional
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "map.fill")
                    .foregroundColor(.blue)
                Text("Parking Locations")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding()
            
            Picker("Parking Type", selection: $selectedItem) {
                ForEach(ParkingSelection.allCases) { selection in
                    Text(selection.rawValue).tag(selection)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            NavigationView {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        if selectedItem == .LOT {
                            LotGridView(lots: lots)
                        } else {
                            BuildingGridView(buildings: buildings)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct LotGridView: View {
    var lots: [Lot]
    
    var body: some View {
        if lots.isEmpty {
            Text("No Lots Available")
                .foregroundColor(.gray)
                .padding()
        } else {
            ForEach(lots.filter { $0.availableSpots > 0 }, id: \.id) { lot in
                NavigationLink(
                    destination: ChooseSpot(spotSelection: .lot(lot))
                ) {
                    ParkingItemView(title: lot.name, icon: "car.fill")
                }
                .padding(.vertical, 4)
            }
        }
    }
}


struct BuildingGridView: View {
    var buildings: [Building]
    
    var body: some View {
        if buildings.isEmpty {
            Text("No Buildings Available")
                .foregroundColor(.gray)
                .padding()
        } else {
            ForEach(buildings.filter { $0.availableSpots > 0 }, id: \.id) { building in
                NavigationLink(
                    destination: ChooseSpot(spotSelection: .building(building))
                ) {
                    ParkingItemView(title: building.name, icon: "building.2.fill")
                }
                .padding(.vertical, 4)
            }
        }
    }
}

struct ParkingItemView: View {
    var title: String
    var icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .padding()
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .fontWeight(.bold)
                .padding(.bottom)
        }
        .frame(width: 120, height: 120)
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

#Preview {
    ChooseLot(lots: lots, buildings: buildings)
}
