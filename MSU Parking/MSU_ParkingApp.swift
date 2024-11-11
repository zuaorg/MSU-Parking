//
//  MSU_ParkingApp.swift
//  MSU Parking
//
//  Created by Zain Ul Abidin on 10/22/24.
//

import SwiftUI

@main
struct MSU_ParkingApp: App {
    var body: some Scene {
        WindowGroup {
            AdminView().environmentObject(DataManager.shared)
        }
    }
}
