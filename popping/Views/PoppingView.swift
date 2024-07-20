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
                PopScreenView()
                    .frame(height: geo.size.height * 0.45)
                
                PopPadView(keyGrid: PopData.popKeyGrid)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    PoppingView()
}
