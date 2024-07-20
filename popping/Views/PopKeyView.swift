//
//  PopKeyView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

struct PopKeyButtonString: ButtonStyle {
    let width:CGFloat
    let key: PopData.PopKey
    
    // TODO : IN landscap, border can't be calculated by width
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: width, maxHeight: width)
            .background(configuration.isPressed ? key.colorPressed : key.color)
            .foregroundStyle(.white)
            .font(.system(size: 888))
            .minimumScaleFactor(0.01)
            .clipShape(
                RoundedRectangle(cornerRadius: width / 30)
            )
            .overlay(
                RoundedRectangle(cornerRadius: width / 30)
                    .strokeBorder(key.colorPressed, lineWidth: width / 40)
            )
    }
}

struct PopKeyButtonSFSymbol: ButtonStyle {
    let width:CGFloat
    let key: PopData.PopKey
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: width, maxHeight: width)
            .background(configuration.isPressed ? key.colorPressed : key.color)
            .foregroundStyle(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: width / 30)
            )
            .overlay(
                RoundedRectangle(cornerRadius: width / 30)
                    .strokeBorder(key.colorPressed, lineWidth: width / 40)
            )
    }
}

struct PopKeyView: View {
    let key: PopData.PopKey
    let width: CGFloat
    let action: (_: PopData.PopKey) -> ()
    
    var body: some View {
        if !key.sfImageName.isEmpty {
            Button() {
                action(key)
            } label: {
                Image(systemName: key.sfImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            .buttonStyle(PopKeyButtonSFSymbol(width: width, key: key))
        } else {
            Button(key.stringvalue) {
                action(key)
            }
            .buttonStyle(PopKeyButtonString(width: width, key: key))
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    PopKeyView(key: PopData.PopKey.keyPlus, width: 200) { _ in
        print("key pressed")
    }
}
