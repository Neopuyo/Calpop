//
//  PopKeyView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PopKeyButton: ButtonStyle {
    let width:CGFloat
    let keyKind: PopData.PopKeyKind
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: width, maxHeight: width)
            .background(configuration.isPressed ? keyKind.colorPressed : keyKind.color)
            .foregroundStyle(.white)
            .font(.system(size: 888))
            .minimumScaleFactor(0.01)
            .clipShape(
                RoundedRectangle(cornerRadius: width / 15)
            )
            .overlay(
                RoundedRectangle(cornerRadius: width / 15)
                    .strokeBorder(keyKind.colorPressed, lineWidth: width / 20)
            )
    }
}

struct PopKeyView: View {
    let key: PopData.PopKey
    let width: CGFloat
    let action: (_: PopData.PopKey) -> ()
    
    var body: some View {
        Button(key.symbol) {
            action(key)
        }
        .buttonStyle(PopKeyButton(width: width, keyKind: key.kind))
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    PopKeyView(key: PopData.PopKey("+"), width: 200) { _ in
        print("key pressed")
    }
}
