//
//  LockedFrameView.swift
//  popping
//
//  Created by Loup Martineau on 29/06/2024.
//

import SwiftUI

struct LockedFrameView: View {
    
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack() {
                if #available(iOS 17.0, *) {
                    Rectangle()
                        .fill(Gradient(colors: [Color.blue, Color.mint, Color.blue]))
                } else {
                    Rectangle()
                        .fill(Color.mint)
                }
                
                
                Rectangle()
                    .fill(Color.white)
                    .opacity(0.3)
                    .aspectRatio(1.0, contentMode: .fit)
                    .frame(width:geo.size.height / 3, height: geo.size.height / 3 )
                    .clipShape(RoundedRectangle(cornerRadius: 8.0))
                    
                
                ChildView(width:geo.size.height / 3.2)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width:geo.size.height / 3.2, height: geo.size.height / 3.2 )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
}


// iPhone15Pro viewport
@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 393, height: 852)) {
    LockedFrameView()
}


/* KEEP the containerRelativeFrame solution
 
 if #available(iOS 17.0, *) {
     ZStack() {
         
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
 
 */
