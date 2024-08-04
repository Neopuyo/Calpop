//
//  PopExp.swift
//  popping
//
//  Created by Loup Martineau on 03/08/2024.
//

import Foundation

struct PopExp {
    let leftOperand: String?
    let mathOperator: PopData.MathOperator
    let rightOperand: String
}

enum PopExpError: Error {
    case leftOperandRequired
    case leftOperandForbidden
    case noExpressions
    case unknown
}

extension PopExpError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .leftOperandForbidden: "Left operand is forbidden"
        case .leftOperandRequired: "Left operand is required"
        case .noExpressions: "The expression list is empty"
        case .unknown: "unknown popExpError occured"
        }
    }
}

protocol PopExpDelegate {
    var popExps: [PopExp] { get }
    var popChain: String { get }
    
    func addPopExp(leftOperand: String?, mathOperator: PopData.MathOperator, rightOperand: String) throws
    func addPopExpToChain(_ exp: PopExp) throws
    func resetPopExps()
}



class PopExpHandler : PopExpDelegate {
    var popExps: [PopExp]
    var popChain: String
    
    var isFirst: Bool { popExps.isEmpty }
    
    init() {
        self.popExps = []
        self.popChain = ""
    }
    
    func addPopExp(leftOperand: String? = nil, mathOperator: PopData.MathOperator, rightOperand: String) throws {
        guard !(popExps.isEmpty && leftOperand == nil) else { throw PopExpError.leftOperandRequired }
        guard !(!popExps.isEmpty && leftOperand != nil) else { throw PopExpError.leftOperandForbidden }
        let newPopExp = PopExp(leftOperand: leftOperand, mathOperator: mathOperator, rightOperand: rightOperand)
        popExps.append(newPopExp)
        try addPopExpToChain(newPopExp)
    }
    
    func addPopExpToChain(_ exp: PopExp) throws {
        guard !popExps.isEmpty else { throw  PopExpError.noExpressions }
        guard !(popExps.count == 1) else { try addFirstPopExpChain(); return }
        if exp.mathOperator.isPrioritary {
            popChain = "(\(popChain)) \(exp.mathOperator.expSymbol) \(exp.rightOperand)"
        } else {
            popChain = "\(popChain) \(exp.mathOperator.expSymbol) \(exp.rightOperand)"
        }
    }
    
    func resetPopExps() {
        popExps = []
        popChain = ""
    }
    
    private func addFirstPopExpChain() throws {
        let firstExp = popExps[0]
        guard firstExp.leftOperand != nil else { throw PopExpError.leftOperandRequired }
        popChain = "\(firstExp.leftOperand!) \(firstExp.mathOperator.expSymbol) \(firstExp.rightOperand)"
    }

    
}
