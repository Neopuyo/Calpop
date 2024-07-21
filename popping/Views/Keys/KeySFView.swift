//
//  KeySFView.swift
//  popping
//
//  Created by Loup Martineau on 21/07/2024.
//

import SwiftUI

struct KeySFView: View {
    let key: PopData.PopKey
    let finalSize: CGSize
    let paddingSize: CGSize
    let action: (_: PopData.PopKey) -> ()
    
    var body: some View {
        Button() {
            action(key)
        } label: {
            Image(systemName: key.sfImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
        }
        .buttonStyle(PopKeyButtonSFSymbol(finalSize: finalSize, key: key))
        .padding(.horizontal, paddingSize.width)
        .padding(.vertical, paddingSize.height)
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    KeySFView(key: PopData.PopKey.keyPlusSlashMinus, finalSize: CGSize(width: 100, height: 50), paddingSize: CGSize(width: 10, height: 5)) { _ in
        print("key pressed")
    }
}
