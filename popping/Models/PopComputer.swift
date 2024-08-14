//
//  Popcomputer.swift
//  popping
//
//  Created by Loup Martineau on 14/08/2024.
//

import Foundation
import Expression

protocol PopComputerDelegate {
    func keyPressed(_ key: PopData.PopKey)
    
    var displayExpLine: () -> () { get }
    var displayResultLine: () -> () { get }
    var displayNextMathOperator: () -> () { get }
    var displayInputMode: () -> () { get }
    
    var refreshedExpressionLine: String { get }
    var refreshedResultLine: String? { get }
    var refreshedNextMathOperator: PopData.MathOperator? { get }
    var refreshedInputMode: PopData.InputMode { get }
    
}

class PopComputer : PopComputerDelegate {
    
    private var popExpHandler: PopExpHandler = PopExpHandler()
    private var popMemoryHandler: PopMemoryHandler = PopMemoryHandler()
    
    private var tempResultLine: String = ""
    private var tempExpressionLine: String = ""
    
    private var inputMode:PopData.InputMode = .left {
        didSet { displayInputMode() }
    }
    
    private var isError = false {
        didSet { updateDisplays() }
    }
    
    private var leftOperand:String? = nil
    private var rightOperand:String? = nil
    private var mathOperator:PopData.MathOperator? = nil
    private var nextMathOperator:PopData.MathOperator? = nil
    
    
    var displayExpLine: () -> () = {}
    var displayResultLine: () -> () = {}
    var displayNextMathOperator: () -> () = {}
    var displayInputMode: () -> () = {}
    
    private var isReadyToCompute: Bool { leftOperand != nil && mathOperator != nil && rightOperand != nil }
    
    var refreshedExpressionLine: String {
        guard !isError else { return "" }
        if inputMode == .mathOperator {
            return "\(leftOperand ?? "??")"
        } else if inputMode == .mathOperatorNext {
            return "\(popExpHandler.popChain)" // [+] need better save method improvement display
        } else {
            return ""
        }
    }
    
    var refreshedResultLine: String? {
        guard !isError else { return "ERROR" }
        switch (inputMode) {
        case .left, .mathOperatorNext:
            return tempResultLine
        case .rightFirst, .rightNext:
            return tempResultLine
        default:
            return nil
        }
    }
    
    var refreshedNextMathOperator: PopData.MathOperator? {
        guard !isError else { return nil }
        return nextMathOperator
    }
    
    var refreshedInputMode: PopData.InputMode {
        return inputMode
    }

    func keyPressed(_ key: PopData.PopKey) {
        switch key.kind {
        case .digit:
            digitPressed(key)
            
        case .digitSpe:
            plusSlashMinusPressed()
            
        case .math:
            guard key != .keyResult  else { resultPressed(); return }
            mathPressed(key)
            
        case .special:
            specialPressed(key)
            
        case .memory:
            popMemoryHandler.memoryKeyPressed(key)
            
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
                print("start new compute from scratch")
                inputMode = .left
                popExpHandler.resetPopExps()
                tempResultLine = ""
                tempExpressionLine = ""
                displayExpLine()
            } else {
                // chain compute from previous result
                print("chain compute from previous result")
                inputMode = .rightNext
                tempResultLine = ""
            }
        case .rightNext:
            break
        }
        tempResultLine.append(key.stringValue)
        displayResultLine()
    }
    
    private func plusSlashMinusPressed() {
        // WIP
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
        displayExpLine()
        // update ResltLine too ?
    }
    
    private func rightSideFinished(with mathKey: PopData.PopKey) {
        guard !tempResultLine.isEmpty else { setOrSwapOperator(with: mathKey); return }
        rightOperand = tempResultLine
        tempResultLine = ""
        evaluateCurrentExpression(nextOP: PopData.MathOperator.getMathOperator(from: mathKey.stringValue))
    }
        
    private func setOrSwapOperator(with mathKey: PopData.PopKey) {
        guard let currentOperator = PopData.MathOperator.getMathOperator(from: mathKey.stringValue) else { isError = true ; return }
        mathOperator = currentOperator
        nextMathOperator = currentOperator
        displayNextMathOperator()
        displayExpLine()
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
            nextMathOperator = nil
            inputMode = .left
            isError = false
            popExpHandler.resetPopExps()
            updateDisplays()
        case .keyClearEntry:
            // [C] clear Entry
            tempResultLine = ""
            displayResultLine()
        case .keyDelete:
            guard !(inputMode == .mathOperator || inputMode == .mathOperatorNext) else { return }
            guard !tempResultLine.isEmpty else { return }
            tempResultLine.remove(at: tempResultLine.index(before: tempResultLine.endIndex))
            displayResultLine()
            
        default:
            print("CONTINUE IMPLEMENTING THIS")
        }
    }
    
    /// Obj-C func can't be try catch easily
    private func evaluateCurrentExpression(nextOP:PopData.MathOperator? = nil) {
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
            mathOperator = nextOP
            nextMathOperator = nextOP
            inputMode = .mathOperatorNext
            updateDisplays()
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
    
    private func formatInputBeforeEvaluate(_ input:String) -> String {
        let input = input.replacingOccurrences(of: "x", with: "*")
        return input
    }
    
    private func updateDisplays() {
        displayExpLine()
        displayResultLine()
        displayNextMathOperator()
    }
    
    
    
    // MARK: DEBUG SHORTHAND
    func checkValues() {
        print("MODE : \(inputMode.rawValue)")
        print("LeftOperand : \(leftOperand ?? "nil")")
        print("rightOperand : \(rightOperand ?? "nil")")
        print("mathOperator : \(mathOperator?.expSymbol ?? "nil")")
        print("nextMathOperator : \(nextMathOperator?.expSymbol ?? "nil")")
        print("tempExpressionLine : '\(tempExpressionLine)'")
        print("tempResultLine : '\(tempResultLine)'")
        print("")
    }
    

}
