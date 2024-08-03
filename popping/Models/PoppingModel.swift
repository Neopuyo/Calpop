//
//  PoppingModel.swift
//  popping
//
//  Created by Loup Martineau on 13/07/2024.
//

import SwiftUI
import Expression


class PoppingModel: ObservableObject {
    
    private var tempExpressionLine: String = ""
    @Published var displayedExpressionLine: String = ""
    
    
    private var tempResultLine: String = ""
    @Published var displayedResultLine: String = ""
    
    @Published var isError: Bool = false
    @Published var inputMode:PopData.InputMode = .left

    var getLeftOperandResult: String {
        guard let left = leftOperand else { return "L_OP_Err_nil" }
        return evaluateExpression(from: left) ?? "L_OP_Err_eval"
    }

    
//    private var currentInput:String = ""
//    private var expressions: [String] = []
    private var popExpHandler: PopExpHandler = PopExpHandler()
    
//    private var isChainingComputes: Bool = false => better inside inputMode steps
    
    private var leftOperand:String? = nil
    private var rightOperand:String? = nil
    private var mathOperator:PopData.MathOperator? = nil
    private var isReadyToCompute: Bool { leftOperand != nil && mathOperator != nil && rightOperand != nil }
    
    
    
    func keyPressed(_ key: PopData.PopKey) {
        switch key.kind {
        case .digit:
            digitPressed(key)
            
        case .math:
            guard key != .keyResult  else { resultPressed(); return }
            mathPressed(key)
            
        case .special:
            specialPressed(key)
            
        default:
            print("🌵 [\(key.kind.rawValue)] key not handled yet")
        }
    }
    
    
    private func digitPressed(_ key: PopData.PopKey) {
        switch inputMode {
        case .left:
            break
        case .mathOperator:
            inputMode = .rightFirst
        case .rightFirst:
            break
        case .mathOperatorNext:
            if mathOperator == nil {
                // start new compute from scratch
                inputMode = .left
//                expressions = []
                popExpHandler.resetPopExps()
                tempResultLine = ""
                tempExpressionLine = ""
                updateDisplayedExpressionLine()
            } else {
                // chain compute from previous result
                inputMode = .rightNext
                tempResultLine = ""
            }
        case .rightNext:
            break
        }
        tempResultLine.append(key.stringValue)
        updateDisplayedResultLine()
    }
    
    private func mathPressed(_ mathKey: PopData.PopKey) {
        switch inputMode {
        case .left:
            leftSideFinished(with: mathKey)
        case .mathOperator, .mathOperatorNext:
            setOrSwapOperator(with: mathKey)
        case .rightFirst, .rightNext:
            rightSideFinished(with: mathKey)
        }
    }
    
    private func resultPressed() {
        switch inputMode {
        case .left:
            return
        case .mathOperator, .mathOperatorNext:
            return
        case .rightFirst, .rightNext:
            guard !tempResultLine.isEmpty else { return }
            rightOperand = tempResultLine
            tempResultLine = ""
            evaluateCurrentExpression()
        }
    }
    
    private func leftSideFinished(with mathKey: PopData.PopKey) {
        if tempResultLine.isEmpty {
            leftOperand = "0"
        } else {
            leftOperand = tempResultLine
            tempResultLine = ""
        }
        setOrSwapOperator(with: mathKey)
        inputMode = .mathOperator
        updateDisplayedExpressionLine()
        // update ResltLine too ?
    }
    
    private func rightSideFinished(with mathKey: PopData.PopKey) {
        guard !tempResultLine.isEmpty else { setOrSwapOperator(with: mathKey); return }
        rightOperand = tempResultLine
        tempResultLine = ""
        evaluateCurrentExpression()
        
    }
        
    private func setOrSwapOperator(with mathKey: PopData.PopKey) {
        guard let currentOperator = PopData.MathOperator.getMathOperator(from: mathKey.stringValue) else { isError = true; return }
        mathOperator = currentOperator
        updateDisplayedExpressionLine()
    }
    
    
    private func specialPressed(_ key: PopData.PopKey) {
        switch key {
        case .keyClear:
            // [C] clear all
            tempResultLine = ""
            tempExpressionLine = ""
            leftOperand = nil
            rightOperand = nil
            mathOperator = nil
            inputMode = .left
            isError = false
            updateDisplayedResultLine()
            updateDisplayedExpressionLine()
        case .keyClearEntry:
            // [C] clear Entry
            tempResultLine = ""
            updateDisplayedResultLine()
        case .keyDelete:
            guard !(inputMode == .mathOperator || inputMode == .mathOperatorNext) else { return }
            guard !tempResultLine.isEmpty else { return }
            tempResultLine.remove(at: tempResultLine.index(before: tempResultLine.endIndex))
            updateDisplayedResultLine()
            
        default:
            print("CONTINUE IMPLEMENTING THIS")
        }
    }
    
    /// Obj-C func can't be try catch easily
    private func evaluateCurrentExpression() {
        guard isReadyToCompute else {
            print("Error evaluateCurrentExpression : !isReadyToCompute")
            isError = true
            return
        }
        // [N] : The three following force unwraps are guaranted by the guard statement above
        let formatedLeft: String = formatInputBeforeEvaluate(leftOperand!)
        let formatedRight: String = formatInputBeforeEvaluate(rightOperand!)
        let expressionString: String = "\(formatedLeft) \(mathOperator!.expSymbol) \(formatedRight)"
        
        let expression : Expression = Expression(expressionString)
        do {
            let expressionResult: Double = try expression.evaluate()
            let isFirst: Bool = popExpHandler.isFirst
            try popExpHandler.addPopExp(leftOperand: isFirst ? leftOperand : nil, mathOperator: mathOperator!, rightOperand: rightOperand!)
            tempResultLine = String(expressionResult)
            leftOperand! = String(expressionResult) // [+] need better save method improvement display // popExpHandler.popChain ???
            rightOperand = nil
            mathOperator = nil
            inputMode = .mathOperatorNext
            updateDisplayedExpressionLine()
            updateDisplayedResultLine()
        } catch {
            print("ERROR EVALUATING CURRENT")
            print(error.localizedDescription)
            isError = true
        }
    }
    
    private func evaluateExpression(from exp: String) -> String? {
        let expression : Expression = Expression(exp)
        do {
            let expressionResult: Double = try expression.evaluate()
            return String(expressionResult)
        } catch {
            print("ERROR EVALUATING '\(exp)'")
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func updateDisplayedExpressionLine() {
        if inputMode == .mathOperator {
            displayedExpressionLine = "\(leftOperand ?? "??") \(mathOperator?.expSymbol ?? "$$")"
        } else if inputMode == .mathOperatorNext {
            displayedExpressionLine = "\(popExpHandler.popChain) \(mathOperator?.expSymbol ?? "")" // [+] need better save method improvement display
        } else if tempExpressionLine.isEmpty {
            displayedExpressionLine = ""
        }
    }
    
    private func updateDisplayedResultLine() {
        switch (inputMode) {
        case .left, .mathOperatorNext:
            displayedResultLine = tempResultLine
        case .rightFirst, .rightNext:
            displayedResultLine = tempResultLine
        default:
            break
        }
    }
    
//    private func makeCurrentChainExp() -> String {
//        guard !expressions.isEmpty else { return "" }
//        var chainExp: String = ""
//        for exp in expressions {
//            chainExp += "[\(exp)] "
//        }
//        return chainExp
//    }
    
    private func formatInputBeforeEvaluate(_ input:String) -> String {
        let input = input.replacingOccurrences(of: "x", with: "*")
        return input
    }
    
    
    
    // MARK: DEBUG SHORTHAND
    func checkValues() {
        print("MODE : \(inputMode.rawValue)")
        print("LeftOperand : \(leftOperand ?? "nil")")
        print("rightOperand : \(rightOperand ?? "nil")")
        print("mathOperator : \(mathOperator?.expSymbol ?? "nil")")
        print("tempExpressionLine : '\(tempExpressionLine)'")
        print("tempResultLine : '\(tempResultLine)'")
        print("")
    }
    
}



