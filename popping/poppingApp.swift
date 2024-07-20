//
//  poppingApp.swift
//  popping
//
//  Created by Loup Martineau on 29/06/2024.
//

import SwiftUI

@main
struct poppingApp: App {

    @StateObject private var popping = PoppingModel()

    var body: some Scene {
        
        WindowGroup {
            PoppingView()
                .environmentObject(popping)
        }
    }
}
