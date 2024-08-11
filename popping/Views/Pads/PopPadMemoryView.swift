//
//  PopPadMemoryView.swift
//  popping
//
//  Created by Loup Martineau on 21/07/2024.
//

import SwiftUI

struct PopPadMemoryView: View {
    @EnvironmentObject var popping: PoppingModel
    let keyGrid: [PopData.PopKey] = PopData.popKeyGridMemory
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing:0) {
                ForEach(0..<6) { i in
                    PopKeyView(
                        keyStyle: .keyMemory,
                        key: keyGrid[i],
                        size: CGSize(
                            width: (geo.size.width - ((27 * 2) * geo.size.width / 396 )) * 1 / 6,
                            height: geo.size.height * 25 / 50
                        ),
                        action: popping.keyPressed
                    )
                }
            }
            .padding(.horizontal, geo.size.width * 27 / 396)
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 396, height: 50)) {
    PopPadMemoryView()
        .environmentObject(PoppingModel())
}
