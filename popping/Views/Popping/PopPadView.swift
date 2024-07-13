//
//  PopPadView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PopPadView: View {
    
    @ObservedObject var popping: PoppingModel
    let keyGrid: [[PopData.PopKey]]
    
    var body: some View {
        GeometryReader { geo in
            
            if #available(iOS 17.0, *) {
                Grid {
                    ForEach(0..<6) { i in
                        GridRow {
                            ForEach(0..<4) { j in
                                PopKeyView(
                                    key: keyGrid[i][j],
                                    width: geo.size.width / CGFloat(4),
                                    action: popping.keyPressed
                                )
                            }
                        }
                    }
                }
            } else {
                VStack {
                    ForEach(0..<6) { i in
                        HStack {
                            ForEach(0..<4) { j in
                                PopKeyView(
                                    key: keyGrid[i][j],
                                    width: geo.size.width / CGFloat(4),
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
    PopPadView(popping: PoppingModel(), keyGrid: PopData.popKeyGrid)
}
