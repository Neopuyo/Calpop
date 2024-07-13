//
//  PopKey.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

class PopData {
    
    enum PopKeyKind: String {
        case digit
        case math
        case special
        case empty
        case unknown
        
        var color: Color {
            switch self {
            case .digit:
                return Color.mouikyColorTurquoiseBlue
            case .math:
                return Color.mouikyColorBrightGreen
            case .special:
                return Color.mouikyColorTangerine
            case .empty:
                return Color.gray
            default:
                return Color.mouikyColorHibiscus
            }
        }
        
        var colorPressed: Color {
            switch self {
            case .digit:
                return Color.mouikyColorAzurBlueDarker1
            case .math:
                return Color.mouikyColorAzurBlueDarker1
            case .special:
                return Color.mouikyColorAzurBlueDarker1
            case .empty:
                return Color.black
            default:
                return Color.mouikyColorAzurBlueDarker1
            }
        }
        
        static func getKindOf(symbol: String) -> PopKeyKind {
            switch symbol {
            case "":
                return .empty
            case "0"..."9", " ", ".":
                return .digit
            case "+", "-", "/", "*", "x":
                return .math
            case "C", "AC", "=", "+/-":
                return .special
            default:
                return .unknown
            }
        }
    }
    
    struct PopKey {
        let symbol: String
        let kind: PopKeyKind
        
        init(_ symbol: String) {
            self.symbol = symbol
            self.kind = PopKeyKind.getKindOf(symbol:symbol)
        }
    }
    
    static let popKeyGrid: [[PopKey]] = [
        [ PopKey("+/-"), PopKey(""), PopKey("C"), PopKey("AC") ],
        [ PopKey(""), PopKey(""), PopKey(""), PopKey("/") ],
        [ PopKey("7"), PopKey("8"), PopKey("9"), PopKey("x") ],
        [ PopKey("4"), PopKey("5"), PopKey("6"), PopKey("-") ],
        [ PopKey("1"), PopKey("2"), PopKey("3"), PopKey("+") ],
        [ PopKey(" "), PopKey("0"), PopKey("."), PopKey("=") ],
    ]
    
}
