//
//  ChooseLot.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/29/24.
//

import SwiftUI

struct ChooseLot: View {
    var entrances: [entrance] = DataManager.shared.entrances
    var body: some View {
        Text("Choose Entrance")
        
        List(entrances, id: \.id) { entrance in
            NavigationLink(destination: ChooseSpot()) {
                                Text("Choose Spot")
                            }
                        }
                        .navigationTitle("Clickable List")
            
        }
        }


#Preview {
    ChooseLot()
}
