//
//  childView.swift
//  popping
//
//  Created by Loup Martineau on 29/06/2024.
//

import SwiftUI

struct ChildView: View {
    
    let width: CGFloat
    
    var body: some View {
        ZStack() {
//          Circle()
//                .fill(Color.pink)
            KeyButtonView(keyLabel: "5", width:width)
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    ChildView(width: 300)
}
