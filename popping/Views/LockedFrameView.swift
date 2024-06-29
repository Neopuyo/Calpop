//
//  LockedFrameView.swift
//  popping
//
//  Created by Loup Martineau on 29/06/2024.
//

import SwiftUI

struct LockedFrameView: View {
    var body: some View {
            ZStack() {
                Rectangle()
                    .fill(Gradient(colors: [Color.blue, Color.mint, Color.blue]))
                    
                
                Rectangle()
                    .fill(Color.white)
                    .opacity(0.3)
                    .aspectRatio(1.0, contentMode: .fit)
                    .containerRelativeFrame(.vertical) { hight, axis in
                        hight / 3
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                
                ChildView()
                    .aspectRatio(1, contentMode: .fit)
                    .containerRelativeFrame(.vertical) { hight, _ in
                        hight / 3.2
                    }
                    
                
            }
            .edgesIgnoringSafeArea(.all)
        
    }
}

// iPhone15Pro viewport
#Preview(traits: .fixedLayout(width: 393, height: 852)) {
    LockedFrameView()
}
