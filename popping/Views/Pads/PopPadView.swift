//
//  PopPadView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PopPadView: View {
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing:0) {
                
                PopPadMemoryView()
                    .frame(height: geo.size.height * 50 / 518.5)
                
                HStack(spacing:0) {
                    PopPadLeftView()
                        .frame(width: (geo.size.width * 3/4))
                    
                    PopPadRightView()
                        .frame(width: (geo.size.width * 1/4))
                }
                
            }
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 396, height: 550)) {
    PopPadView()
        .environmentObject(PoppingModel())
}
