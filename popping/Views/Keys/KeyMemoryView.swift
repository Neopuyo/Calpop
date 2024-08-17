//
//  KeyMemoryView.swift
//  popping
//
//  Created by Loup Martineau on 21/07/2024.
//

import SwiftUI

struct KeyMemoryView: View {
    let key: PopData.PopKey
    let finalSize: CGSize
    let paddingSize: CGSize
    @EnvironmentObject var popping: PoppingModel
    
    let action: (_: PopData.PopKey) -> ()
    
    var body: some View {
        Button(key.stringValue) {
            action(key)
        }
        .buttonStyle(PopMemoryKeyButton(finalSize: finalSize, key: key, isDisabled: isMemoryButtonDisabled))
        .disabled(isMemoryButtonDisabled)
        .padding(.horizontal, paddingSize.width)
//        .padding(.vertical, paddingSize.height)
    }
    
    private var isMemoryButtonDisabled: Bool {
        guard !(key == .keyMplus || key == .keyMminus || key == .keyMS || key == .keyMmenu) else
        { return false }
        
        return !popping.isMemory
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    KeyMemoryView(key: PopData.PopKey.keyMS, finalSize: CGSize(width: 47 * 3, height: 25 * 3), paddingSize: CGSize(width: 10, height: 5)) { _ in
        print("key pressed")
    }
}
