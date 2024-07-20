//
//  PopPadLeftView.swift
//  popping
//
//  Created by Loup Martineau on 20/07/2024.
//

import SwiftUI

struct PopPadLeftView: View {
    @EnvironmentObject var popping: PoppingModel
    let keyGrid: [[PopData.PopKey]] = PopData.popKeyGridLeft
    
    var body: some View {
        GeometryReader { geo in
            
            if #available(iOS 17.0, *) {
                Grid(horizontalSpacing: 0, verticalSpacing: 0) {
                    ForEach(0..<6) { i in
                        GridRow {
                            ForEach(0..<3) { j in
                                PopKeyView(
                                    key: keyGrid[i][j],
                                    size: CGSize(
                                        width: geo.size.width / CGFloat(3),
                                        height: geo.size.height / CGFloat(6)
                                    ),
                                    action: popping.keyPressed
                                )
                            }
                        }
                    }
                }
            } else {
                VStack(spacing:0) {
                    ForEach(0..<6) { i in
                        HStack(spacing:0) {
                            ForEach(0..<3) { j in
                                PopKeyView(
                                    key: keyGrid[i][j],
                                    size: CGSize(
                                        width: geo.size.width / CGFloat(3),
                                        height: geo.size.height / CGFloat(6)
                                    ),
                                    action: popping.keyPressed
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    PopPadLeftView()
        .environmentObject(PoppingModel())
}
