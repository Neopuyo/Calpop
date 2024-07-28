//
//  PopKeyButtonStyles.swift
//  popping
//
//  Created by Loup Martineau on 21/07/2024.
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
            .clipShape(
                RoundedRectangle(cornerRadius: finalSize.width / 30)
            )
            .overlay(
                RoundedRectangle(cornerRadius: finalSize.width / 30)
                    .strokeBorder(key.colorPressed, lineWidth: finalSize.width / 40)
            )
    }
}


struct PopMemoryKeyButton: ButtonStyle {
    let finalSize: CGSize
    let key: PopData.PopKey
    
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: finalSize.width, height: finalSize.height)
            .background(configuration.isPressed ? key.colorPressed : key.color)
            .font(.system(size: 888))
            .minimumScaleFactor(0.01)
            .clipShape(
                RoundedRectangle(cornerRadius: finalSize.width / 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: finalSize.width / 8)
                    .strokeBorder(key.colorPressed, lineWidth: finalSize.width / 40)
            )
    }
}
