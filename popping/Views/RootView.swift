//
//  RootView.swift
//  popping
//
//  Created by Loup Martineau on 06/07/2024.
//

import SwiftUI


struct RootView: View {
    
    var body: some View {
        if #available(iOS 17.0, *) {
            NavigationStack() {
                    List {
                        NavigationLink(destination: LockedFrameView()) {
                            Text("Locked Frame")
                        }
                        
                        // Pad
                        NavigationLink(destination: Text("Work in progress - View")) {
                            Text("Work in progress")
                        }
                        
                    }
                }
            
        } else {
            NavigationView {
                List {
                    // LockedFrameView
                    NavigationLink(destination: LockedFrameView()) {
                        Text("Locked Frame")
                    }
                    
                    // Pad
                    NavigationLink(destination: ComputePadView()) {
                        Text("ComputePad")
                    }
                    
                }
            }
            .navigationViewStyle(.stack)
        }
    }
        
}

#Preview {
    RootView()
}
