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
    var displayMemoryStock: () -> () { get }
    var toogleMemoryPannel: () -> () { get }
    
    var refreshedExpressionLine: String { get }
    var refreshedResultLine: String? { get }
    var refreshedNextMathOperator: PopData.MathOperator? { get }
    var refreshedInputMode: PopData.InputMode { get }
    var refreshedMemoryStock: [MemoItem] { get }
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
    var toogleMemoryPannel: () -> () = {}
    var displayMemoryStock: () -> () = {} {
        didSet { popMemoryHandler.displayMemoryStock = displayMemoryStock }
    }
    var displayMemoryCurrent: () -> () = {} {
        didSet { popMemoryHandler.displayMemoryCurrent = displayMemoryCurrent }
    }

    
    private var isReadyToCompute: Bool { 
        leftOperand != nil && mathOperator != nil && rightOperand != nil
    }
    
    var refreshedExpressionLine: String {
        guard !isError else { return "" }
        switch inputMode {
        case .mathOperator:
            return "\(leftOperand ?? "??")"
        case .mathOperatorNext:
            return "\(popExpHandler.prepareChain())"
        case .left, .rightNext, .rightFirst:
            return ""
        }
    }
    
    var refreshedResultLine: String? {
        guard !isError else { return "ERROR" }
        switch (inputMode) {
        // [+] clean this
        case .left, .mathOperator, .mathOperatorNext, .rightFirst, .rightNext:
            return tempResultLine
            
//        default:
//            return nil
        }
    }
    
    var refreshedNextMathOperator: PopData.MathOperator? {
        guard !isError else { return nil }
        return nextMathOperator
    }
    
    var refreshedInputMode: PopData.InputMode {
        return inputMode
    }
    
    var refreshedMemoryStock: [MemoItem] {
        return popMemoryHandler.memoryStock
    }
    
    var refreshedCurrentMemoryItem: MemoItem? {
        return popMemoryHandler.currentMemoryItem
    }
    
    var clearEntryAvailable: Bool {
        !tempResultLine.isEmpty && inputMode != .mathOperator && inputMode != .mathOperatorNext
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
            memoryPressed(key)
            
            
        default:
            print("🌵 [\(key.kind.rawValue)] key not handled yet")
        }
    }
    
    func memoryAction(_ action: PopMemoryAction) {
        popMemoryHandler.memoryAction(action)
    }
    
    private func memoryPressed(_ key: PopData.PopKey) {
        switch (key) {
        case .keyMmenu:
            toogleMemoryPannel()
            
        case .keyMminus, .keyMplus:
            handleMemoryAddAction(method: key == .keyMplus ? .add : .substract)
            
        case .keyMS:
            handleMemoryStockAction(method: .add)
            
        case .keyMC:
            handleMemoryClearAction()
            
        case .keyMR:
            handleMemoryRecallAction()
            
        default:
            print("Error. This key '\(key)' isn't a memory one. This shouldn't happen.")
        }
        popMemoryHandler.memoryKeyPressed(key) // [?] Utility ?
    }
    
    private func handleMemoryAddAction(method: PopMemoryAction.Method) {
        guard !popMemoryHandler.isEmpty else { handleMemoryStockAction(method: method); return }
        
        switch inputMode {
        case .left:
            popMemoryHandler.memoryAction(.add(tempResultLine.isEmpty ? "0" : tempResultLine, method))
            
        case .mathOperator:
            popMemoryHandler.memoryAction(.add(leftOperand ?? "0", method))
            
        case .rightFirst, .rightNext:
            print("handleMemoryAddAction wrong case reached : M+ and M- buttons should be disabled") // [?][!]
            return
            
        case .mathOperatorNext:
            popMemoryHandler.memoryAction(.add(popExpHandler.prepareChain(), method))
        }
    }
    
    private func handleMemoryStockAction(method: PopMemoryAction.Method) {
        switch inputMode {
        case .left:
            popMemoryHandler.memoryAction(.create(tempResultLine.isEmpty ? "0" : tempResultLine, method))
        
        case .mathOperator:
            popMemoryHandler.memoryAction(.create(leftOperand ?? "0", method))
            
        case .rightFirst, .rightNext:
            print("handleMemoryStockAction wrong case reached : MS button should be disabled") // [?][!]
            return
            
        case .mathOperatorNext:
            popMemoryHandler.memoryAction(.create(popExpHandler.prepareChain(), method))
 
        }
    }
    
    private func handleMemoryClearAction() {
        popMemoryHandler.memoryAction(.clear)
    }
    
    private func handleMemoryRecallAction() {
        switch inputMode {
        case .left:
            startChainWithMemoryRecallItem()
            
        case .mathOperator, .rightFirst:
            computeWithMemoryRecallAsRightOperand(isNext: false)
            
        case .mathOperatorNext, .rightNext:
            computeWithMemoryRecallAsRightOperand(isNext: true)
 
        }
    }
    
    // [N] will replace tempResultline input if there is one
    private func startChainWithMemoryRecallItem() {
        guard let memo = popMemoryHandler.currentMemoryItem else { return }
        tempResultLine = memo.result
        leftOperand = memo.exp
        do {
            try popExpHandler.addPopExp(PopExp.fromMemoRecall(memo, nil))
        } catch {
            return
        }
        displayResultLine()
        inputMode = .mathOperatorNext
    }
    
    private func computeWithMemoryRecallAsRightOperand(isNext: Bool) {
        guard let memo = popMemoryHandler.currentMemoryItem, let op = mathOperator else { return }
        rightOperand = memo.exp
        if !isNext {
            do {
                try popExpHandler.addPopExp(PopExp.fromMemoRecall(memo, op))
            } catch {
                return
            }
        }
        evaluateCurrentExpression()
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
    
    // No throw possible with negate case
    private func plusSlashMinusPressed() {
        switch inputMode {
            
        case .left, .rightFirst, .rightNext:
            resultLineToggledByNegate()
            
        case .mathOperator:
            return
            
        case .mathOperatorNext:
            mathOperatorNextToggledByNegate()
        }
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
        case .left, .mathOperator:
            return
        case  .mathOperatorNext:
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
    
    // [+] check if func arg is needed here
    private func leftSideFinishedBySpecialFunc(_ speFunc: PopExp) {
        if tempResultLine.isEmpty {
            leftOperand = "0"
        } else {
            leftOperand = tempResultLine
            tempResultLine = ""
        }
        
        do {
            try popExpHandler.addPopExp(PopExp.singleValue(leftOperand!))
        } catch {
            print("leftSideFinishedBySpecialKey Error")
            isError = true
            return
        }
        inputMode = .mathOperatorNext
    }
    
    private func resultLineToggledByNegate() {
        if tempResultLine.isEmpty {
            return
        } else {
            if tempResultLine.first == "-" {
                tempResultLine = String(tempResultLine.dropFirst())
            } else {
                tempResultLine = "-\(tempResultLine)"
            }
            displayResultLine()
        }
    }
    
    // [!] access to popExpHandler.isNegTerminated will produce data races !
    private func mathOperatorNextToggledByNegate() {
        let memoNegative:Bool = tempResultLine.first == "-"
        try! popExpHandler.addPopExp(PopExp.negate)
        
        if memoNegative {
            tempResultLine = String(tempResultLine.dropFirst())
        } else {
            tempResultLine = "-\(tempResultLine)"
        }
        displayResultLine()
    }
    
    private func rightSideFinished(with mathKey: PopData.PopKey) {
        guard !tempResultLine.isEmpty else { setOrSwapOperator(with: mathKey); return }
        rightOperand = tempResultLine
        tempResultLine = ""
        evaluateCurrentExpression(nextOP: PopData.MathOperator.getMathOperator(from: mathKey.stringValue))
    }
    
    private func rightSideFinishedBySpecialFunc(_ speFunc: PopExp) {
        guard mathOperator != nil else { return } // [+] error ?
        rightOperand = tempResultLine
        tempResultLine = ""
        evaluateCurrentExpression(nextOP: PopData.MathOperator.getMathOperator(from: mathOperator!.rawValue))
    }
    
    private func resetNextMathOperator() {
        mathOperator = nil
        nextMathOperator = nil
        displayNextMathOperator()
    }
    
    private func mathOperatorReplacedBySpecialFunc(_ speFunc: PopExp) {
        resetNextMathOperator()
        tempResultLine = leftOperand ?? "0"
        leftSideFinishedBySpecialFunc(speFunc)
    }
        
    private func setOrSwapOperator(with mathKey: PopData.PopKey) {
        guard let currentOperator = PopData.MathOperator.getMathOperator(from: mathKey.stringValue) else { isError = true ; return }
        mathOperator = currentOperator
        nextMathOperator = currentOperator
        displayNextMathOperator()
        displayExpLine()
    }
    
    
    // [+] Refractor it
    private func specialPressed(_ key: PopData.PopKey) {
        switch key {
        case .keyClearEntry:
            clearEntryAvailable ? clearEntry() : clearAll()
        case .keyDelete:
            guard !(inputMode == .mathOperator || inputMode == .mathOperatorNext) else { return }
            guard !tempResultLine.isEmpty else { return }
            tempResultLine.remove(at: tempResultLine.index(before: tempResultLine.endIndex))
              // Memo : fix deleted when only "-" from +/- special digit
            if tempResultLine.first == "-" && tempResultLine.count == 1 {
                tempResultLine = ""
            }
            displayResultLine()
        case .keyInverse, .keyPower2, .keySquareRoot, .keyPercent:
            resolveSpecialFunction(key)
        default:
            print("🪽 CONTINUE IMPLEMENTING THIS")
        }
    }
    
    private func clearAll() {
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
    }
    
    private func clearEntry() {
        tempResultLine = ""
        displayResultLine()
    }
    
    private func resolveSpecialFunction(_ key: PopData.PopKey) {
        guard key == .keyInverse || key == .keyPower2 || key == .keySquareRoot || key == .keyPercent else { return } // [+] manage it better with a PopComputer error class ?
        guard let specialFunc = PopExp.KeyDict[key] else { return }
        
        switch inputMode {
        case .left:
            leftSideFinishedBySpecialFunc(specialFunc)
        case .mathOperator:
            mathOperatorReplacedBySpecialFunc(specialFunc)
        case .rightFirst, .rightNext:
            rightSideFinishedBySpecialFunc(specialFunc)
        case .mathOperatorNext:
            resetNextMathOperator()
        }

        do {
            try popExpHandler.addPopExp(specialFunc)
            try popExpHandler.evaluateSpecialExpression()
        } catch {
            print("Error resolveSpecialFunction") // [+] will need error class
            isError = true // [+] not an error if only ExpressionEmpty Error
        }
    
//        checkValues()
        tempExpressionLine = popExpHandler.prepareChain()
        if let result = evaluateExpression(from: tempExpressionLine) {
            tempResultLine = result
        }
        displayResultLine()
        displayExpLine()
    }

    
    /// Obj-C func can't be try catch easily
    private func evaluateCurrentExpression(nextOP:PopData.MathOperator? = nil) {
        guard isReadyToCompute else {
            print("Error evaluateCurrentExpression : !isReadyToCompute") // [+] will need error class
            isError = true
            return
        }
        let isFirst: Bool = popExpHandler.hasNoNormalExp && !popExpHandler.isSingleValueStarting // [+] bien tester cet ajout conditionnel (&& !popExpHandler.isSingleValueStarting)
        if !isFirst { leftOperand! = popExpHandler.prepareChain() }// get fresh leftOperand : [+] need RFC about left operand handle management ?
        // [N] : The three following force unwraps are guaranted by the guard statement above
        let formatedLeft: String = formatInputBeforeEvaluate(leftOperand!)
        let formatedRight: String = formatInputBeforeEvaluate(rightOperand!)
        let expressionString: String = mathOperator!.isPrioritary ? "(\(formatedLeft)) \(mathOperator!.computeSymbol) \(formatedRight)" : "\(formatedLeft) \(mathOperator!.computeSymbol) \(formatedRight)"
        
        let expression : Expression = Expression(expressionString)
        do {
            let expressionResult: Double = try expression.evaluate()
            let normalExp = NormalPopExp(leftOperand: isFirst ? leftOperand : nil, mathOperator: mathOperator!, rightOperand: rightOperand!)
            try popExpHandler.addPopExp(PopExp.normal(normalExp))
            tempResultLine = String(expressionResult)
            rightOperand = nil
            // leftOperand = nil // [+] is ok ? Améliorer pour ne pas entrer en conflit avec isReadyToCompute lors de chain compute
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
    
    // [N] WIP : Atempt if press Result in .left .mathop inputmode
//    private func evaluateSingleValue() {
//        guard !tempResultLine.isEmpty else { return }
//        leftOperand = tempResultLine
//        do {
//            try popExpHandler.addPopExp(PopExp.singleValue(leftOperand!))
//        } catch {
//            return
//        }
//        tempExpressionLine = popExpHandler.prepareChain()
//        displayExpLine()
//        displayResultLine()
//    }
    
    // [?] not used anymore ? later maybe ?
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
        let input = input
            .replacingOccurrences(of: "􀅾", with: "*")
            .replacingOccurrences(of: "􀅿", with: "/")
            .replacingOccurrences(of: "􀅼", with: "+")
            .replacingOccurrences(of: "􀅽", with: "-")
        print("\(input)")
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
        print("mathOperator : \(mathOperator?.computeSymbol ?? "nil")")
        print("nextMathOperator : \(nextMathOperator?.computeSymbol ?? "nil")")
        print("tempExpressionLine : '\(tempExpressionLine)'")
        print("tempResultLine : '\(tempResultLine)'")
        print("popExpHandler.showPopExps : '\(popExpHandler.showPopExps())'")
        print("")
    }
    

}
