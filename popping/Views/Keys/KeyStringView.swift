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
    
    @EnvironmentObject() var popping: PoppingModel
    
    var body: some View {
        Button(showEntryVariant ? key.stringValueVariant ?? "?" : key.stringValue) {
            action(key)
        }
        .buttonStyle(PopKeyButtonString(finalSize: finalSize, key: key))
        .padding(.horizontal, paddingSize.width)
        .padding(.vertical, paddingSize.height)
    }
    
    private var showEntryVariant : Bool {
        guard key == .keyClearEntry else { return false }
        return popping.clearEntryAvailable
    }
    
}


@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    KeyStringView(key: PopData.PopKey.key8, finalSize: CGSize(width: 100, height: 50), paddingSize: CGSize(width: 10, height: 5)) { _ in
        print("key pressed")
    }
}
