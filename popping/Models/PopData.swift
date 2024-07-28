//
//  PopKey.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

class PopData {
    
    /// The part of the expression the user is currently typing
    enum InputMode:String {
        // First expression
        case left
        case mathOperator
        case rightFirst
        // Chaining expressions
        case mathOperatorNext
        case rightNext
    }
    
    enum MathOperator: String {
        case plus = "+"
        case minus = "-"
        case multiply = "x"
        case divide = "/"
        
        static func getMathOperator(from sign: String) -> MathOperator? {
            switch (sign) {
            case "+":          return .plus
            case "-":          return .minus
            case "*", "x":     return .multiply
            case "/":          return .divide
            
            default:
                print("Error getMathOperator from '\(sign)' that returns nil") // [+] HANDLE ERROR BETTER
                return nil
            }
        }
    }
    
    enum PopKeyKind: String {
        case digit
        case digitSpe
        case math
        case special
        case memory
        case unknown
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
        case keyMC, keyMR, keyMplus, keyMminus, keyMS, keyMmenu
        
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
            case .keyMC, .keyMR, .keyMplus, .keyMminus, .keyMS, .keyMmenu:
                return .memory
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
        
        var stringValue: String {
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
            case .keyMC:                     return "MC"
            case .keyMR:                     return "MR"
            case .keyMplus:                  return "M+"
            case .keyMminus:                 return "M-"
            case .keyMS:                     return "MS"
            case .keyMmenu:                  return "Mv"
                
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
    
    // 6 x 1
    static let popKeyGridMemory: [PopKey] = [ .keyMC, .keyMR, .keyMplus, .keyMminus, .keyMS, .keyMmenu ]
    
    // 3 x 6
    static let popKeyGridLeft: [[PopKey]] = [
        [   .keyClear,                .keyClearEntry,         .keyDelete        ],
        [   .keyInverse,              .keyPower2,             .keySquareRoot    ],
        [   .key7,                    .key8,                  .key9             ],
        [   .key4,                    .key5,                  .key6             ],
        [   .key1,                    .key2,                  .key3             ],
        [   .keyPlusSlashMinus,       .key0,                  .keyDot           ],
    ]
    
    // 1 x (4 + 1bigger)
    static let popKeyGridRight: [PopKey] = [
        .keyDivide,
        .keyMultiply,
        .keyMinus,
        .keyPlus,
        .keyResult, // double size
    ]
        
}
