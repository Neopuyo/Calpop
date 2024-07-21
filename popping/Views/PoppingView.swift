//
//  PoppingView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PoppingView: View {
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing:0) {
                
                // HEADER
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: geo.size.height * 0.08)
                
                
                // SCREEN
                PopScreenView()
                    .frame(height: geo.size.height * 0.45)
                
                // MID SEPARATOR
                Rectangle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(height: geo.size.height * 0.04)
                
                
                // PADS
                PopPadView()
                    .frame(height: geo.size.height * 0.45)
                
                
                
                // FOOTER
                
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    PoppingView()
        .environmentObject(PoppingModel())
}
