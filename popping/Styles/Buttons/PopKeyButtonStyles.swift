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
    
    private var ratio: CGFloat {
        // on iPhone 15 pro, button width is 90
        return finalSize.width / 90.0
    }
    
    @EnvironmentObject() var popping: PoppingModel
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: finalSize.width, height: finalSize.height)
            .foregroundStyle(key.colorForeground)
            .background(configuration.isPressed ? key.colorPressed : key.color)
            .font(.system(size: 30 * ratio, design: .rounded))
            .minimumScaleFactor(0.01)
            .clipShape(
                RoundedRectangle(cornerRadius: finalSize.width / 15)
            )
            .overlay(
                RoundedRectangle(cornerRadius: finalSize.width / 15)
                    .strokeBorder(
                        isMathOperatorSelected ? Color.memoryButton : key.colorBorder,
                        lineWidth: isMathOperatorSelected ? finalSize.width / 20 : finalSize.width / 80
                    )
            )
    }
    
    private var isMathOperatorSelected: Bool {
        guard key.kind == .math && key != .keyResult else { return false }
        guard let mathOperator = popping.displayedNextMathOperator else { return false }
        
        return key.stringValue == mathOperator.rawValue
    }
}

struct PopKeyButtonSFSymbol: ButtonStyle {
    let finalSize: CGSize
    let key: PopData.PopKey
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: finalSize.width * 2 / 3, height: finalSize.height)
            .padding(.horizontal, finalSize.width * 1 / 6)
            .foregroundStyle(key.colorForeground)
            .background(configuration.isPressed ? key.colorPressed : key.color)
            .clipShape(
                RoundedRectangle(cornerRadius: finalSize.width / 15)
            )
            .overlay(
                RoundedRectangle(cornerRadius: finalSize.width / 15)
                    .strokeBorder(
                        key.colorBorder,
                        lineWidth: finalSize.width / 80
                    )
            )
        
    }
}

struct PopKeyMathButton: ButtonStyle {
    let finalSize: CGSize
    let key: PopData.PopKey
    
    @EnvironmentObject() var popping: PoppingModel
    
    
    func makeBody(configuration: Configuration) -> some View {
        let pressed: Bool = (isMathOperatorSelected || configuration.isPressed)
//        let pressed: Bool = (true)
        
        return configuration.label
            .frame(width: finalSize.width * 2 / 3, height: isResultCase ? finalSize.height * 1 / 2 : finalSize.height)
            .padding(.horizontal, finalSize.width * 1 / 6)
            .padding(.top, isResultCase ? finalSize.height * 1 / 2 : 0)
            .foregroundStyle(key.colorForeground)
            .background(pressed ? key.colorPressed : key.color)
            .clipShape(
                RoundedRectangle(cornerRadius: finalSize.width / 15)
            )
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: finalSize.width / 15)
                        .strokeBorder(
                            pressed ? Color.whiteToBlack : key.colorBorder,
                            lineWidth: finalSize.width / 80 * 4
                        )
                    RoundedRectangle(cornerRadius: finalSize.width / 15)
                        .strokeBorder(
                            pressed ? Color.mathBlueAddedBorder : Color.mathBlue,
                            lineWidth: finalSize.width / 80 * 3
                        )
                }
            )
    }
    
    private var isResultCase: Bool {
        return key == .keyResult
    }
    
    private var isMathOperatorSelected: Bool {
        guard key.kind == .math && key != .keyResult else { return false }
        guard let mathOperator = popping.displayedNextMathOperator else { return false }
        
        return key.stringValue == mathOperator.rawValue
    }
    
    
}


struct PopMemoryKeyButton: ButtonStyle {
    let finalSize: CGSize
    let key: PopData.PopKey
    let isDisabled: Bool
    
    private var ratio: CGFloat {
        // on iPhone 15 pro, memorybutton width is 47
        return finalSize.width / 47.0
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: finalSize.width, height: finalSize.height)
            .foregroundStyle(key.colorForeground)
            .background(
                configuration.isPressed || isDisabled ? key.colorPressed : key.color
            )
            .font(.system(size: 15 * ratio, design: .rounded))
            .minimumScaleFactor(0.01)
            .clipShape(
                RoundedRectangle(cornerRadius: finalSize.width / 15 * 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: finalSize.width / 15 * 4)
                    .strokeBorder(
                        isDisabled ? key.color : key.colorBorder,
                        lineWidth: finalSize.width / 80
                    )
            )

    }
    
    
    
    
}
