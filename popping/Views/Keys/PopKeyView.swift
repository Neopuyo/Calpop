//
//  PopKeyView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

enum KeyStyle {
    case keyString, keySF, keyMath, keyMemory, keyResult
}

struct PopKeyView: View {
    let keyStyle: KeyStyle
    let key: PopData.PopKey
    let size: CGSize
    let action: (_: PopData.PopKey) -> ()
    
    private var paddingSize:CGSize {
        switch keyStyle {
        case .keyString, .keySF, .keyMath:
            return CGSize(
                width: size.width / 20,
                height: size.height / 20
            )
        case .keyResult:
            return CGSize(
                width: size.width / 20,
                height: size.height / 40
            )
        case .keyMemory:
            return CGSize(
//                width: 0.0,
                width: 7 * (size.width / (47 + 14)) , // memo button iPhone15pro : pad7 + width47 + pad7
                height: 0.0 // [!] TODO : CHECK HERE memo button shape / paddings
            )
//            return CGSize(
//                width: size.width / 10,
//                height: size.height / 20
//            )
        }
    }
    
    private var finalSize:CGSize {
        CGSize(
            width: size.width - paddingSize.width * 2,
            height: size.height - paddingSize.height * 2
        )
    }
    
    var body: some View {
        switch keyStyle {
        case .keyString:
            KeyStringView(key: key, finalSize: finalSize, paddingSize: paddingSize, action: action)
            
        case .keySF:
            KeySFView(key: key, finalSize: finalSize, paddingSize: paddingSize, action: action)
            
        case .keyMath, .keyResult:
            KeyMathView(key: key, finalSize: finalSize, paddingSize: paddingSize, action: action)
            
        case .keyMemory:
            KeyMemoryView(key: key, finalSize: finalSize, paddingSize: paddingSize, action: action)
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    PopKeyView(keyStyle: .keyString, key: PopData.PopKey.keyPlus, size: CGSize(width: 100, height: 50)) { _ in
        print("key pressed")
    }
    .environmentObject(PoppingModel())
}
