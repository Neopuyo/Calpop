//
//  PopExp.swift
//  popping
//
//  Created by Loup Martineau on 03/08/2024.
//

import Foundation

enum PopExp: Equatable {
    case normal(NormalPopExp)
    case singleValue(String)
    case fromMemoRecall(MemoItem)
    case negate // +/-
    case inverse
    case power2
    case squareRoot
    case percent
    
    
    static func == (lhs: PopExp, rhs: PopExp) -> Bool {
        switch (lhs, rhs) {
        case (.negate, .negate):
            return true
        case (.normal(let nLeft), .normal(let nRight)):
            return nLeft.leftOperand == nRight.leftOperand && nLeft.mathOperator == nRight.mathOperator && nLeft.rightOperand == nRight.rightOperand
        case(.singleValue(let v1), .singleValue(let v2)):
            return v1 == v2
        default:
            return false
        }
    }
    
    static let KeyDict: [PopData.PopKey:PopExp] = [
        .keyPlusSlashMinus : .negate,
        .keyInverse : .inverse,
        .keyPower2 : .power2,
        .keySquareRoot : .squareRoot,
        .keyPercent : .percent,
    ]
    
    var isNormal: Bool {
        switch (self) {
        case .normal(_):
            return true
        default:
            return false
        }
    }
    
    var isSingleValue: Bool {
        switch (self) {
        case .singleValue(_):
            return true
        default:
            return false
        }
    }
    
    var isFromMemoRecall: Bool {
        switch (self) {
        case .fromMemoRecall(_):
            return true
        default:
            return false
        }
    }
    
    var isSpecial: Bool { !isNormal && !isSingleValue && !isFromMemoRecall }
    
    var getExp: NormalPopExp? {
        switch (self) {
        case .normal(let normal):
            return normal
        default:
            return nil
        }
    }
    
    
}

struct NormalPopExp {
    let leftOperand: String?
    let mathOperator: PopData.MathOperator
    let rightOperand: String
}


enum PopExpError: Error {
    case leftOperandRequired
    case leftOperandForbidden
    case singleValueForbidden
    case noExpressions
    case uniqExpression
    case invalidNormalExpValues
    case invalidSpecialExpression
    case specialExpressionNotFound
    case unknown
}

extension PopExpError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .leftOperandForbidden:         "Left operand is forbidden"
        case .leftOperandRequired:          "Left operand is required"
        case .singleValueForbidden:         "Single value Expression can only be found once and as first position in chain expression"
        case .uniqExpression:               "A uniq normal math expression was expected here"
        case .invalidNormalExpValues:       "Wrong values from an expected normal expression"
        case .invalidSpecialExpression:     "The expression is expected to be a special one"
        case .noExpressions:                "The expression list is empty"
        case .specialExpressionNotFound:    "A special expression would be expected"
        case .unknown:                      "unknown popExpError occured"
        }
    }
}
