//
//  KeyButtonView.swift
//  popping
//
//  Created by Loup Martineau on 29/06/2024.
//

import SwiftUI

struct KeyButton: ButtonStyle {
    let width:CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: width, maxHeight: width)
            .background(configuration.isPressed ? Color.mouikyColorAzurBlueDarker1 : Color.mouikyColorAzurBlue)
            .foregroundStyle(.white)
            .font(.system(size: 888))
            .minimumScaleFactor(0.01)
            .clipShape(
                RoundedRectangle(cornerRadius: width / 15)
            )
            .overlay(
                RoundedRectangle(cornerRadius: width / 15)
                    .strokeBorder(Color.mouikyColorAzurBlueDarker1, lineWidth: width / 20)
            )
    }
}

struct KeyButtonView: View {
    
    let keyLabel: String
    let width: CGFloat
    
    var body: some View {
        Button(keyLabel) {
            print("key [\(keyLabel)]")
        }
        .buttonStyle(KeyButton(width:width))
    }
    
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    KeyButtonView(keyLabel: "🦔", width: 300.0)
}
