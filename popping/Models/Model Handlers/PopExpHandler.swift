//
//  PopExpHandler.swift
//  popping
//
//  Created by Loup Martineau on 07/09/2024.
//

import Foundation

protocol PopExpDelegate {
    var popExps: [PopExp] { get }
//    var popChain: String { get }
    
//    func addPopExp(leftOperand: String?, mathOperator: PopData.MathOperator, rightOperand: String) throws
//    func addPopExpToChain(_ exp: PopExp) throws
    func resetPopExps()
}

class PopExpHandler : PopExpDelegate {
    var popExps: [PopExp]
    private var popChain: String
    
    private var countNormalExp: Int = 0
    private(set) var isSingleValueStarting: Bool = false
    private var isNegTerminated: Bool = false
       
    private var getUniqNormal : PopExp? {
        guard countNormalExp == 1 else { return nil }
        return  popExps.first { $0.isNormal }
    }
    
    init() {
        self.popExps = []
        self.popChain = ""
    }
    
    var hasNoNormalExp : Bool { countNormalExp == 0 }
    
    func prepareChain() -> String {
        isNegTerminated ? "(\(popChain)) * -1" : popChain
    }
    

    func addPopExp(_ popExp: PopExp) throws {
        switch (popExp) {
        case .normal(let normalPopExp):
            try addNormalPopExp(leftOperand: normalPopExp.leftOperand, mathOperator: normalPopExp.mathOperator, rightOperand: normalPopExp.rightOperand)
            
        case .singleValue(let value):
            try addSingleValuePopExp(value)
            
        case .negate:
            addNegatePopExp()
            
        case .inverse, .power2, .squareRoot, .percent:
            try addSpecialPopExp(popExp)
            
        case .fromMemoRecall(let memoItem):
            addPopExpFromMemoRecall(memoItem)
            
        }
    }
    

    
    func resetPopExps() {
        popExps = []
        popChain = ""
        countNormalExp = 0
        isNegTerminated = false
        isSingleValueStarting = false
    }
    
    // [N] : the +/- key is not handled here
    func evaluateSpecialExpression() throws {
        guard let specialExp = popExps.last, specialExp.isSpecial else { throw PopExpError.specialExpressionNotFound }
        
        switch (specialExp) {
        case .inverse:
            inverseChain()
        case .power2:
            power2Chain()
        case .squareRoot:
            sqrtChain()
        case .percent:
            percentChain()
            
        default:
            throw PopExpError.specialExpressionNotFound
        }
    }
    
    private func addNegatePopExp() {
        guard !popExps.isEmpty else { return }
        if isNegTerminated {
            popExps.removeLast()
            isNegTerminated = false
        } else {
            popExps.append(PopExp.negate)
            isNegTerminated = true
        }
    }
    
    private func addSpecialPopExp(_ specialExp: PopExp) throws {
        guard !popExps.isEmpty else { throw PopExpError.noExpressions }
        guard specialExp.isSpecial else { throw PopExpError.invalidSpecialExpression}
        popExps.append(specialExp)
    }
    
    private func inverseChain() {
        popChain = "1 / (\(popChain))"
    }
    
    private func power2Chain() {
        popChain = "pow(\(popChain), 2)"
    }
    
    private func sqrtChain() {
        popChain = "sqrt(\(popChain))"
    }
    
    private func percentChain() {
        popChain = "(\(popChain)) / 100"
    }
    
    private func addNormalPopExp(leftOperand: String? = nil, mathOperator: PopData.MathOperator, rightOperand: String) throws {
        guard !(countNormalExp == 0 && !isSingleValueStarting && leftOperand == nil) else { throw PopExpError.leftOperandRequired }
        guard !(countNormalExp > 0 && leftOperand != nil) else { throw PopExpError.leftOperandForbidden }
        if isNegTerminated {
            resolveNegTerminated()
        }
        let normalExp = NormalPopExp(leftOperand: leftOperand, mathOperator: mathOperator, rightOperand: rightOperand)
        let newPopExp = PopExp.normal(normalExp)
        popExps.append(newPopExp)
        countNormalExp += 1
        isNegTerminated = false
        try addNormalPopExpToChain(normalExp)
    }
    
    private func addSingleValuePopExp(_ value: String) throws {
        guard popExps.isEmpty, !isSingleValueStarting else { throw PopExpError.singleValueForbidden }
        popExps.append(PopExp.singleValue(value))
        popChain = value
        isSingleValueStarting = true
    }
    
    private func addPopExpFromMemoRecall(_ memoItem: MemoItem) {
        popExps.append(PopExp.fromMemoRecall(memoItem))
        // [!] gérer le cas du isNegterminated, + autres fonctions spés ? dans le mode .left ça a l'air ok
        if popChain.isEmpty {
            popChain = memoItem.exp
        } else  {
            popChain = "\(popChain) + (\(memoItem.exp))"
        }
    }
    
    private func resolveNegTerminated() {
        guard isNegTerminated else { return }
        popChain = "(\(popChain)) * -1"
    }
    
    private func addNormalPopExpToChain(_ exp: NormalPopExp) throws {
        guard countNormalExp != 0 else { throw  PopExpError.noExpressions }
        guard !(countNormalExp == 1 && !isSingleValueStarting) else { try addFirstNormalPopExpChain(); return }
        
        if exp.mathOperator.isPrioritary {
            popChain = "(\(popChain)) \(exp.mathOperator.computeSymbol) \(exp.rightOperand)"
        } else {
            popChain = "\(popChain) \(exp.mathOperator.computeSymbol) \(exp.rightOperand)"
        }
    }
    
    private func addFirstNormalPopExpChain() throws {
        guard let firstNormal = getUniqNormal else { throw PopExpError.uniqExpression }
        guard let exp = firstNormal.getExp else { throw PopExpError.invalidNormalExpValues }
        
        popChain = "\(exp.leftOperand!) \(exp.mathOperator.computeSymbol) \(exp.rightOperand)"
    }
    
    // MARK: DEBUG
    func showPopExps() -> String {
        var toPrint:String = ""
        for exp in popExps {
            switch (exp) {
            case .normal(let n):
                toPrint += "[\(n.leftOperand ?? "")\(n.leftOperand == nil ? "" : " ")\(n.mathOperator) \(n.rightOperand)]"
            case .singleValue(let v):
                toPrint += "[\(v)]"
            case .fromMemoRecall(let m):
                toPrint += "[(MR~\(m.result))]"
            case.negate:
                toPrint += "[negate]"
            case .inverse:
                toPrint += "[inverse]"
            case .power2:
                toPrint += "[pow2]"
            case .squareRoot:
                toPrint += "[sqrt]"
            case .percent:
                toPrint += "[percent]"
            }
        }
        return toPrint
    }
    
}
