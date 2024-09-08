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
    let action: (_: PopData.PopKey) -> ()

    @EnvironmentObject var popping: PoppingModel
    
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
        switch (key, popping.displayedInputMode) {
        case (.keyMS, .rightFirst),     (.keyMS, .rightNext),
             (.keyMplus, .rightFirst),  (.keyMplus, .rightNext),
             (.keyMminus, .rightFirst), (.keyMminus, .rightNext) :
            return true

            // [N] call Recall will replace the temp input
//        case (.keyMR, .rightFirst),      (.keyMR, .rightNext):
//            return true
            
        case (.keyMS, _),
             (.keyMplus, _),
             (.keyMminus, _) :
            return false
        
        default:
            return  popping.displayedMemoryStock.isEmpty
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    KeyMemoryView(key: PopData.PopKey.keyMS, finalSize: CGSize(width: 47 * 3, height: 25 * 3), paddingSize: CGSize(width: 10, height: 5)) { _ in
        print("key pressed")
    }
}
