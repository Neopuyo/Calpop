//
//  PopExp.swift
//  popping
//
//  Created by Loup Martineau on 03/08/2024.
//

import Foundation

enum PopExp:Equatable {
    
    case normal(NormalPopExp)
    case negate // +/-
    
    static func == (lhs: PopExp, rhs: PopExp) -> Bool {
        switch (lhs, rhs) {
        case (.negate, .negate):
            return true
        case (.normal(let nLeft), .normal(let nRight)):
            return nLeft.leftOperand == nRight.leftOperand && nLeft.mathOperator == nRight.mathOperator && nLeft.rightOperand == nRight.rightOperand
        default:
            return false
        }
    }
    
    var isNormal: Bool {
        switch (self) {
        case .normal(_):
            return true
        default:
            return false
        }
    }
    
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
    case noExpressions
    case uniqExpression
    case invalidNormalExpValues
    case unknown
}

extension PopExpError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .leftOperandForbidden: "Left operand is forbidden"
        case .leftOperandRequired: "Left operand is required"
        case .uniqExpression: "A uniq normal math expression was expected here"
        case .invalidNormalExpValues: "Wrong values from an expected normal expression"
        case .noExpressions: "The expression list is empty"
        case .unknown: "unknown popExpError occured"
        }
    }
}

protocol PopExpDelegate {
    var popExps: [PopExp] { get }
    var popChain: String { get }
    
//    func addPopExp(leftOperand: String?, mathOperator: PopData.MathOperator, rightOperand: String) throws
//    func addPopExpToChain(_ exp: PopExp) throws
    func resetPopExps()
}



class PopExpHandler : PopExpDelegate {
    var popExps: [PopExp]
    var popChain: String
    
    private var countNormalExp:Int = 0
       
    private var getUniqNormal : PopExp? {
        guard countNormalExp == 1 else { return nil }
        return  popExps.first { $0.isNormal }
    }
    
    init() {
        self.popExps = []
        self.popChain = ""
    }
    
    var hasNoNormalExp : Bool { countNormalExp == 0 }
    
//    var refreshedPopChain: String? {
//        get {
//            convertExpToChain()
//        }
//    }
    
//    private func convertExpToChain() -> String? {
//        return nil
//    }

    func addPopExp(_ popExp: PopExp) throws {
        switch (popExp) {
        case .normal(let normalPopExp):
            try addNormalPopExp(leftOperand: normalPopExp.leftOperand, mathOperator: normalPopExp.mathOperator, rightOperand: normalPopExp.rightOperand)
        case .negate:
            return
//            addNegatePopExp()
        }
    }
    
    func resetPopExps() {
        popExps = []
        popChain = ""
        countNormalExp = 0
    }
    
    
//    private func addNegatePopExp() {
//        guard !popExps.isEmpty else { return }
//        if let lastExp = popExps.last {
//            if lastExp == .negate {
//                popExps.removeLast()
//                isNegTerminated = false
//            } else {
//                popExps.append(PopExp.negate)
//                isNegTerminated = true
//            }
//        } else {
//            print("addNegatePopExp popExps.last returned nil -> Unexpected ")
//        }
//    }
    
    private func addNormalPopExp(leftOperand: String? = nil, mathOperator: PopData.MathOperator, rightOperand: String) throws {
        guard !(countNormalExp == 0 && leftOperand == nil) else { throw PopExpError.leftOperandRequired }
        guard !(countNormalExp > 0 && leftOperand != nil) else { throw PopExpError.leftOperandForbidden }
        let normalExp = NormalPopExp(leftOperand: leftOperand, mathOperator: mathOperator, rightOperand: rightOperand)
        let newPopExp = PopExp.normal(normalExp)
        popExps.append(newPopExp)
        countNormalExp += 1
        try addNormalPopExpToChain(normalExp)
    }
    
    private func addNormalPopExpToChain(_ exp: NormalPopExp) throws {
        guard countNormalExp != 0 else { throw  PopExpError.noExpressions }
        guard countNormalExp != 1 else { try addFirstNormalPopExpChain(); return }
        
        if exp.mathOperator.isPrioritary {
            popChain = "(\(popChain)) \(exp.mathOperator.expSymbol) \(exp.rightOperand)"
        } else {
            popChain = "\(popChain) \(exp.mathOperator.expSymbol) \(exp.rightOperand)"
        }
    }
    
    private func addFirstNormalPopExpChain() throws {
        guard let firstNormal = getUniqNormal else { throw PopExpError.uniqExpression }
        guard let exp = firstNormal.getExp else { throw PopExpError.invalidNormalExpValues }
        
        popChain = "\(exp.leftOperand!) \(exp.mathOperator.expSymbol) \(exp.rightOperand)"
    }
    
    // MARK: DEBUG
    func showPopExps() -> String {
        var toPrint:String = ""
        for exp in popExps {
            switch (exp) {
            case .normal(let n):
                toPrint += "[\(n.leftOperand ?? "")\(n.leftOperand == nil ? "" : " ")\(n.mathOperator) \(n.rightOperand)]"
            case.negate:
                toPrint += "[negate]"
            }
        }
        return toPrint
    }
    
}
