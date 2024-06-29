//
//  KeyButtonView.swift
//  popping
//
//  Created by Loup Martineau on 29/06/2024.
//

import SwiftUI

struct KeyButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            .background(configuration.isPressed ? .blue.opacity(0.5) : .blue)
            .foregroundStyle(.white)
            .font(.system(size: 888))
            .minimumScaleFactor(0.01)
            .clipShape(
                RoundedRectangle(cornerRadius: 8.0)
            )
    }
}

struct KeyButtonView: View {
    
    let keyLabel: String = "🦔"
    
    var body: some View {
        Button(keyLabel) {
            
        }
        .buttonStyle(KeyButton())

      
    }
}

#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    KeyButtonView()
}
