//
//  childView.swift
//  popping
//
//  Created by Loup Martineau on 29/06/2024.
//

import SwiftUI

struct ChildView: View {
    var body: some View {
        ZStack() {
//          Circle()
//                .fill(Color.pink)
            KeyButtonView()
        }
    }
}

#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    ChildView()
}
