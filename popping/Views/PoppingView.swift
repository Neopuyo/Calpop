//
//  PoppingView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PoppingView: View {
    
    @EnvironmentObject var popping: PoppingModel
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing:0) {
                
                // HEADER
                Spacer()
                    .frame(height: geo.size.height * 58 / 932)
                
                
                // SCREEN
                PopScreenView(ratio: geo.size.height / 932)
                    .frame(height: geo.size.height * 286 / 932)
                
                // MID SEPARATOR
                Spacer()
                    .frame(height: geo.size.height * 38 / 932)
                
                
                // PADS
                PopPadView()
//                    .frame(height: geo.size.height * 0.45)
                
                
                // FOOTER
                Spacer()
                    .frame(height: geo.size.height * 38 / 932)
                
            }
            .ignoresSafeArea()
            .padding(.horizontal, geo.size.height * 17 / 932 )
            .sheet(isPresented: $popping.showMemoryPannel, content: {
                MemoryStockMenuView(heightRatio: geo.size.height / 932)
            })
        }
    }
}

#Preview {
    PoppingView()
        .environmentObject(PoppingModel.previewSampleData)
}
