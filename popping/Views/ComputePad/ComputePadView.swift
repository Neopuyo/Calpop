//
//  ComputePadView.swift
//  popping
//
//  Created by Loup Martineau on 06/07/2024.
//

import SwiftUI

struct ComputePadView: View {
    
    // [+] store theses datas in a another file / viewmodel
    //     using computed properties to get row and line count
    //     + use a kind of guard to make sure all lines count are equal
//    let line0: [String] = ["7", "8", "9", "+",]
//    let line1: [String] = ["4", "5", "6", "-",]
//    let line2: [String] = ["7", "8", "9", "/",]
//    let line3: [String] = [".", "0", " ", "x",]
    
    let keyGrid: [[String]] = [
        ["7", "8", "9", "+",],
        ["4", "5", "6", "-",],
        ["1", "2", "3", "x",],
        [".", "0", " ", "/",],
    ]
    
//    let linesCount: Int
//    let rowsCount: Int

//    init() {
//        keyGrid = [line0, line1, line2, line3]
//        linesCount = line0.count
////        rowsCount = keyGrid.count
//        // ForEach using this and id: \.self is bug on iphone7 or more probably i used it wrong
//    }
    
    var body: some View {
        GeometryReader { geo in
            
            if #available(iOS 17.0, *) {
                Grid {
                    ForEach(0..<4) { i in
                        GridRow {
                            ForEach(0..<4) { j in
                                KeyButtonView(keyLabel: keyGrid[i][j], width: geo.size.width / CGFloat(4))
                            }
                        }
                    }
                }
            } else {
                VStack {
                    ForEach(0..<4) { i in
                        HStack {
                            ForEach(0..<4) { j in
                                KeyButtonView(keyLabel: keyGrid[i][j], width: geo.size.width / CGFloat(4))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ComputePadView()
}
