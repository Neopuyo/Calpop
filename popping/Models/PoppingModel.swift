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
    private var expressions: [String] = []
    
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
            inputMode = .rightNext
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
            tempResultLine = ""
            tempExpressionLine = ""
            inputMode = .left
            isError = false
            updateDisplayedResultLine()
            updateDisplayedExpressionLine()
        case .keyClearEntry:
            tempResultLine = ""
            updateDisplayedResultLine()
        case .keyDelete:
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
        let expressionString: String = "\(formatedLeft) \(mathOperator!.rawValue) \(formatedRight)"
        
        let expression : Expression = Expression(expressionString)
        do {
            let expressionResult: Double = try expression.evaluate()
            expressions.append(expressionString)
            tempResultLine = String(expressionResult)
            leftOperand! = String(expressionResult) // [+] need better save method improvement display
            rightOperand = nil
            mathOperator = nil
            inputMode = .mathOperatorNext
            updateDisplayedExpressionLine()
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
            displayedExpressionLine = "\(leftOperand ?? "??") \(mathOperator?.rawValue ?? "$$")"
        }
        
//        else if inputMode == .mathOperatorNext {
//            expressionLine = expressions.last! + " =" // [+] need better save method improvement display
//        }
    }
    
    private func updateDisplayedResultLine() {

    }
    
    
    private func formatInputBeforeEvaluate(_ input:String) -> String {
        let input = input.replacingOccurrences(of: "x", with: "*")
        return input
    }
    
    
    
    // MARK: DEBUG SHORTHAND
    func checkValues() {
        print("MODE : \(inputMode.rawValue)")
        print("LeftOperand : \(leftOperand ?? "nil")")
        print("rightOperand : \(rightOperand ?? "nil")")
        print("mathOperator : \(mathOperator?.rawValue ?? "nil")")
        print("tempExpressionLine : '\(tempExpressionLine)'")
        print("tempResultLine : '\(tempResultLine)'")
        print("")
    }
    
}



