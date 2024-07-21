//
//  KeyStringView.swift
//  popping
//
//  Created by Loup Martineau on 21/07/2024.
//

import SwiftUI

struct KeyStringView: View {
    let key: PopData.PopKey
    let finalSize: CGSize
    let paddingSize: CGSize
    let action: (_: PopData.PopKey) -> ()
    
    
    var body: some View {
        Button(key.stringValue) {
            action(key)
        }
        .buttonStyle(PopKeyButtonString(finalSize: finalSize, key: key))
        .padding(.horizontal, paddingSize.width)
        .padding(.vertical, paddingSize.height)
    }
}


@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    KeyStringView(key: PopData.PopKey.key8, finalSize: CGSize(width: 100, height: 50), paddingSize: CGSize(width: 10, height: 5)) { _ in
        print("key pressed")
    }
}
