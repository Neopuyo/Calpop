//
//  PopKeyView.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

// TODO : IN landscap, border can't be calculated by width
struct PopKeyButtonString: ButtonStyle {
    let finalSize: CGSize
    let key: PopData.PopKey
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: finalSize.width, height: finalSize.height)
            .background(configuration.isPressed ? key.colorPressed : key.color)
            .foregroundStyle(.white)
            .font(.system(size: 888))
            .minimumScaleFactor(0.01)
            .clipShape(
                RoundedRectangle(cornerRadius: finalSize.width / 30)
            )
            .overlay(
                RoundedRectangle(cornerRadius: finalSize.width / 30)
                    .strokeBorder(key.colorPressed, lineWidth: finalSize.width / 40)
            )
    }
}

struct PopKeyButtonSFSymbol: ButtonStyle {
    let finalSize: CGSize
    let key: PopData.PopKey
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: finalSize.width, height: finalSize.height)
            .background(configuration.isPressed ? key.colorPressed : key.color)
            .foregroundStyle(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: finalSize.width / 30)
            )
            .overlay(
                RoundedRectangle(cornerRadius: finalSize.width / 30)
                    .strokeBorder(key.colorPressed, lineWidth: finalSize.width / 40)
            )
    }
}

struct PopKeyView: View {
    let key: PopData.PopKey
    let size: CGSize
    let action: (_: PopData.PopKey) -> ()
    
    private var paddingSize:CGSize {
        guard key != PopData.PopKey.keyResult else {
            return CGSize(
                width: size.width / 20,
                height: size.height / 40
            )
        }
        return CGSize(
            width: size.width / 20,
            height: size.height / 20
        )
    }
    
    private var finalSize:CGSize {
        
        CGSize(
            width: size.width - paddingSize.width * 2,
            height: size.height - paddingSize.height * 2
        )
    }
    
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
            .buttonStyle(PopKeyButtonSFSymbol(finalSize: finalSize, key: key))
            .padding(.horizontal, paddingSize.width)
            .padding(.vertical, paddingSize.height)
//            .padding(.vertical, key != PopData.PopKey.keyResult ? paddingSize.height : paddingSize.height - paddingSize.height / 2)
        } else {
            Button(key.stringvalue) {
                action(key)
            }
            .buttonStyle(PopKeyButtonString(finalSize: finalSize, key: key))
            .padding(.horizontal, paddingSize.width)
            .padding(.vertical, paddingSize.height)
        }
    }
}

@available(iOS 17, *)
#Preview(traits: .fixedLayout(width: 300, height: 300)) {
    PopKeyView(key: PopData.PopKey.keyPlus, size: CGSize(width: 100, height: 50)) { _ in
        print("key pressed")
    }
}
