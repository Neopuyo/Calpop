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
            HStack(spacing:0) {
                PopPadLeftView()
                    .frame(width: (geo.size.width * 3/4))
                
                PopPadRightView()
                    .frame(width: (geo.size.width * 1/4))
            }
            
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    PopPadView()
        .environmentObject(PoppingModel())
}
