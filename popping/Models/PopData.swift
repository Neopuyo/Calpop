//
//  PopKey.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI

class PopData {
    
    /// The part of the expression the user is currently typing
    enum InputMode: String {
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
            case "+", "􀅼":                 return .plus
            case "-", "􀅽":                 return .minus
            case "*", "􀅾", "x":            return .multiply
            case "/", "􀅿":                 return .divide
            
            default:
                print("Error getMathOperator from '\(sign)' that returns nil") // [+] HANDLE ERROR BETTER
                return nil
            }
        }
        
        static let scalarPlus =  String(Unicode.Scalar(0x2B)!)
        static let scalarMinus =  String(Unicode.Scalar(0x2212)!)
        static let scalarDivide =  String(Unicode.Scalar(0x00F7)!)
        static let scalarMultiply =  String(Unicode.Scalar(0x00D7)!)

        var computeSymbol: String {
            switch (self) {
                case .plus:     return "+"
                case .minus:    return "-"
                case .divide:   return "/"
                case .multiply: return "*"
            }
        }
        
        var isPrioritary: Bool {
            return self == .divide || self == .multiply
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
        case keyClearEntry, keyPercent, keyDelete, keyInverse, keyPower2, keySquareRoot
        
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
            case .keyClearEntry, .keyPercent, .keyDelete, .keyInverse, .keyPower2, .keySquareRoot:
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
                return Color.whiteToBlack
            case .math:
                return Color.mathBlue
            case .special:
                return Color.specialBlue
            case .memory:
                return Color.memoryButton
            default:
                return Color.whiteToBlack
            }
        }
        
        var colorPressed: Color {
            switch self.kind {
            case .digit, .digitSpe:
                return Color.whiteToBlackPressed
            case .math:
                return Color.mathBluePressed
            case .special:
                return Color.specialBluePressed
            case .memory:
                return Color.memoryButtonPressed
            default:
                return Color.whiteToBlackPressed
            }
        }
        
        var colorBorder: Color {
            switch (self.kind) {
            case .digit, .digitSpe, .special:
                return Color.mathBlue
            case .memory:
                return Color.memoryButtonPressed
            default:
                return self.color
            }
        }
        
        var colorForeground: Color {
            guard !(self.kind == .digit || self.kind == .digitSpe) else { return Color.mathBlue }
            return Color.whiteToBlack
        }
        
        var stringValueVariant: String? {
            switch self {
            case .keyClearEntry:
                return "CE"
            default:
                return nil
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
            case .keyPercent:                return "%"
            case .keyClearEntry:             return "C"
            case .keyResult:                 return "="
            case .keyInverse:                return "1/x"
            case .keyPower2:                 return "x²"
            case .keyMC:                     return "MC"
            case .keyMR:                     return "MR"
            case .keyMplus:                  return "M +"
            case .keyMminus:                 return "M -"
            case .keyMS:                     return "MS"
            case .keyMmenu:                  return "M \(String(Unicode.Scalar(0x2193)!))"
                
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
            case .keyPercent:                return "percent"
                
            default:                         return ""
            }
        }
        
        
        
        
    }
    
    // 6 x 1
    static let popKeyGridMemory: [PopKey] = [ .keyMC, .keyMR, .keyMplus, .keyMminus, .keyMS, .keyMmenu ]
    
    // 3 x 6
    static let popKeyGridLeft: [[PopKey]] = [
        [   .keyPercent,              .keyClearEntry,         .keyDelete        ],
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
