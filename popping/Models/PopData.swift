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
        case digitSpe
        case math
        case special
        case memory
        case unknown
        
//        var color: Color {
//            switch self {
//            case .digit, .digitSpe:
//                return Color.mouikyColorTurquoiseBlue
//            case .math:
//                return Color.mouikyColorBrightGreen
//            case .special:
//                return Color.mouikyColorTangerine
//            case .memory:
//                return Color.mouikyColorButterCup
//            default:
//                return Color.mouikyColorHibiscus
//            }
//        }
        
//        var colorPressed: Color {
//            switch self {
//            case .digit:
//                return Color.mouikyColorAzurBlueDarker1
//            case .math:
//                return Color.mouikyColorAzurBlueDarker1
//            case .special:
//                return Color.mouikyColorAzurBlueDarker1
//            case .memory:
//                return Color.mouikyColorAzurBlueDarker1
//            default:
//                return Color.mouikyColorAzurBlueDarker1
//            }
//        }
        
//        static func getKindOf(symbol: String) -> PopKeyKind {
//            switch symbol {
//            case "":
//                return .empty
//            case "0"..."9", " ", ".":
//                return .digit
//            case "+", "-", "/", "*", "x":
//                return .math
//            case "C", "AC", "=", "+/-":
//                return .special
//            default:
//                return .unknown
//            }
//        }
    }
    
    enum PopKey: String {
        // PopKeyKind.digit
        case key0, key1, key2, key3, key4
        case key5, key6, key7, key8, key9
        case keyDot
        
        // PopKeyKind.digitSpe
        case keyPlusSlashMinus
        
        // PopKeyKind.math
        case keyPlus, keyMinus, keyMultiply, keyDivide, keyResult
        
        // PopKeyKind.special
        case keyClearEntry, keyClear, keyDelete, keyInverse, keyPower2, keySquareRoot
        
        // PopKeyKind.memory
        
        // Later adjustement ?
        case keyUnknown
        
        var kind: PopKeyKind {
            switch self {
            case .key0, .key1, .key2, .key3, .key4, .key5, .key6, .key7, .key8, .key9, .keyDot:
                return .digit
            case .keyPlusSlashMinus:
                return .digitSpe
            case .keyDivide, .keyMultiply, .keyMinus, .keyPlus, .keyResult:
                return .math
            case .keyClearEntry, .keyClear, .keyDelete, .keyInverse, .keyPower2, .keySquareRoot:
                return .special
            default:
                return .unknown
            }
        }
        
        var color: Color {
            switch self.kind {
            case .digit, .digitSpe:
                return Color.mouikyColorTurquoiseBlue
            case .math:
                return Color.mouikyColorBrightGreen
            case .special:
                return Color.mouikyColorTangerine
            case .memory:
                return Color.mouikyColorButterCup
            default:
                return Color.mouikyColorTurquoiseBlue
            }
        }
        
        var colorPressed: Color {
            switch self.kind {
            case .digit, .digitSpe:
                return Color.mouikyColorAzurBlueDarker1
            case .math:
                return Color.mouikyColorAzurBlueDarker1
            case .special:
                return Color.mouikyColorAzurBlueDarker1
            case .memory:
                return Color.mouikyColorAzurBlueDarker1
            default:
                return Color.mouikyColorAzurBlueDarker1
            }
        }
        
        var stringvalue: String {
            switch self {
            case .key0:                      return "0"
            case .key1:                      return "1"
            case .key2:                      return "2"
            case .key3:                      return "3"
            case .key4:                      return "4"
            case .key5:                      return "5"
            case .key6:                      return "6"
            case .key7:                      return "7"
            case .key8:                      return "8"
            case .key9:                      return "9"
            case .keyDot:                    return "."
            case .keyPlus:                   return "+"
            case .keyMinus:                  return "-"
            case .keyDivide:                 return "/"
            case .keyMultiply:               return "x"
            case .keyClear:                  return "C"
            case .keyClearEntry:             return "CE"
            case .keyResult:                 return "="
            case .keyInverse:                return "1/x"
            case .keyPower2:                 return "x^2"
                
            default:                         return ""
            }
        }
        
        var sfImageName: String {
            switch self {
            case .keyPlus:                   return "plus"
            case .keyMinus:                  return "minus"
            case .keyDivide:                 return "divide"
            case .keyMultiply:               return "multiply"
            case .keyDelete:                 return "delete.backward"
            case .keyPlusSlashMinus:         return "plus.forwardslash.minus"
            case .keySquareRoot:             return "x.squareroot"
            case .keyResult:                 return "equal"
                
            default:                         return ""
            }
        }
        
        
        
        
    }
    
//    struct PopKey {
//        let symbol: PopKeySymbol
//        let kind: PopKeyKind
//        
//        init(_ symbol: PopKeySymbol) {
//            self.symbol = PopKeySymbol
//        }
//    }
    
//    static let popKeyGrid: [[PopKey]] = [
//        [PopKey.key9],
//    ]
    
    // 3 x 6
    static let popKeyGridLeft: [[PopKey]] = [
        [    PopKey.keyClear,              PopKey.keyClearEntry,       PopKey.keyDelete        ],
        [    PopKey.keyInverse,            PopKey.keyPower2,           PopKey.keySquareRoot    ],
        [    PopKey.key7,                  PopKey.key8,                PopKey.key9             ],
        [    PopKey.key4,                  PopKey.key5,                PopKey.key6             ],
        [    PopKey.key1,                  PopKey.key2,                PopKey.key3             ],
        [    PopKey.keyPlusSlashMinus,     PopKey.key0,                PopKey.keyDot           ],
    ]
    
    static let popKeyGridRight: [PopKey] = [
        PopKey.keyDivide,
        PopKey.keyMultiply,
        PopKey.keyMinus,
        PopKey.keyPlus,
        PopKey.keyResult, // double size
    ]
    
}
