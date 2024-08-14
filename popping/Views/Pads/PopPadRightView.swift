//
//  PopPadRightView.swift
//  popping
//
//  Created by Loup Martineau on 20/07/2024.
//

import SwiftUI

struct PopPadRightView: View {
    
    @EnvironmentObject var popping: PoppingModel
    let keyGrid: [PopData.PopKey] = PopData.popKeyGridRight
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing:0) {
                ForEach(0..<4) { i in
                    PopKeyView(
                        keyStyle: .keyMath,
                        key: keyGrid[i],
                        size: CGSize(
                            width: geo.size.width,
                            height: geo.size.height * 1 / 6
                        ),
                        action: popping.keyPressed
                    )
                }
                PopKeyView(
                    keyStyle: .keyResult,
                    key: keyGrid[4],
                    size: CGSize(
                        width: geo.size.width,
                        height: (geo.size.height * 2 / 6)
                    ),
                    action: popping.keyPressed
                )
            }
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 100, height: 420)) {
    PopPadRightView()
        .environmentObject(PoppingModel())
}
