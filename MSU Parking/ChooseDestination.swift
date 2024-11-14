//
//  ChooseLot.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/29/24.
//

import SwiftUI

var destinations = DataManager.shared.entrances
var lots = DataManager.shared.lots  // Access the shared data
var buildings = DataManager.shared.buildings

struct ChooseDestination: View {
    @State private var selectedRegion: Region = .NORTH  // Track the selected region
    
    var filteredDestinations: [Entrance] {
        destinations.filter { $0.region == selectedRegion }
    }
    
    var body: some View {
        NavigationView {
                    VStack {
                        // Title with Icon
                        HStack {
                            
                            Text("Destination")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .padding()
                        
                        // Picker for selecting the region
                        Picker("Select Region", selection: $selectedRegion) {
                            ForEach(Region.allCases) { region in
                                Text(region.rawValue).tag(region)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        // ScrollView for the list to allow it to be scrollable
                        ScrollView {
                            // Display destinations or show a "No available destination" message
                            if filteredDestinations.isEmpty {
                                Text("No Building Found!")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                    ForEach(filteredDestinations, id: \.id) { destination in
                                        NavigationLink(
                                            destination: ChooseLot(lots: filteredLots(for: destination), buildings: filteredBuildings(for: destination))
                                        ) {
                                            VStack {
                                                Image(systemName: "building.2.fill")
                                                    .foregroundColor(.blue)
                                                
                                                Text(destination.name)
                                                    .font(.headline)
                                                    .foregroundColor(.primary)
                                                    .fontWeight(.bold)
                                            }
                                            .frame(width: 100, height: 100)
                                            .padding()
                                            .background(Color(UIColor.systemGray6))
                                            .cornerRadius(8)
                                            .shadow(radius: 1)
                                            
                                            
                                        }
                                        .padding(.vertical, 4)
                                    }
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
    }
    
    // Function to filter lots based on nearest destination
    private func filteredLots(for destination: Entrance) -> [Lot] {
        lots.filter { $0.nearestEntranceId == destination.id }
    }
    
    // Function to filter buildings based on nearest destination
    private func filteredBuildings(for destination: Entrance) -> [Building] {
        buildings.filter { $0.nearestEntranceId == destination.id }
    }
}


#Preview {
    ChooseDestination()
}


